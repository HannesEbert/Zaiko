import 'dart:async';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/notifications/notification_ids.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../core/notifications/notification_service.dart';

part 'cook_timers.freezed.dart';
part 'cook_timers.g.dart';

/// Fallback duration for a step that has no recipe-defined timer but is still
/// interacted with (see [kInitialCookTimer]).
const _kDefaultDuration = Duration(minutes: 5);

/// The coarse (minute) and fine (second) steps the cook mode adjusts a timer by.
const kCookTimerMinuteStep = Duration(minutes: 1);
const kCookTimerSecondStep = Duration(seconds: 10);

/// Lower bound for a timer's duration — small enough for short steps, but never
/// zero (a countdown ends by ticking out, not by the "-" button).
const _kMinDuration = Duration(seconds: 5);

/// Upper bound, so holding "+" can't run the timer away.
const _kMaxDuration = Duration(minutes: 180);

/// How often a running timer ticks down.
const _kTick = Duration(seconds: 1);

/// Where a step timer stands.
enum CookTimerStatus {
  /// Set up but not started; [CookTimer.remaining] equals the configured value.
  idle,

  /// Counting down.
  running,

  /// Started, then paused; [CookTimer.remaining] holds the time left.
  paused,

  /// Reached zero; the expiry alert has fired.
  finished,
}

/// A single step's countdown in the cook mode.
///
/// [configured] is the duration the timer starts from (seeded from the recipe
/// step, then adjustable); [remaining] is what is left while `running`/`paused`
/// (and equals [configured] while `idle`).
@freezed
abstract class CookTimer with _$CookTimer {
  const factory CookTimer({
    required Duration configured,
    required Duration remaining,
    required CookTimerStatus status,
  }) = _CookTimer;
}

/// The state a step timer begins in when it has no recipe-defined duration.
const kInitialCookTimer = CookTimer(
  configured: _kDefaultDuration,
  remaining: _kDefaultDuration,
  status: CookTimerStatus.idle,
);

/// Holds one manually started countdown per cook-mode step, keyed by step
/// index. Timers are [seed]ed from the recipe's per-step durations; steps the
/// user never touched read as [kInitialCookTimer].
///
/// Kept alive by the [CookModePage] for its whole lifetime, so a running timer
/// survives swiping between steps; on leaving the mode the page unmounts, this
/// autoDisposes, and [build]'s `onDispose` cancels every outstanding ticker.
@riverpod
class CookTimers extends _$CookTimers {
  final Map<int, Timer> _tickers = {};

  /// The notification title/body per step, captured on [start] so a running
  /// timer's OS notification can be rescheduled when [adjust] changes its
  /// remaining time.
  final Map<int, (String title, String body)> _notifText = {};

  /// Captured once so cancellations still work while the provider disposes.
  late final NotificationService _notifications = ref.read(
    notificationServiceProvider,
  );

  @override
  Map<int, CookTimer> build() {
    ref.onDispose(_cancelAll);
    return const {};
  }

  CookTimer _timerAt(int step) => state[step] ?? kInitialCookTimer;

  /// Pre-loads the given steps with their recipe-defined durations (idle), so
  /// each step's timer shows its configured time before it is started. Existing
  /// entries are left untouched, so re-seeding never disturbs a running timer.
  void seed(Map<int, Duration> durations) {
    final next = {...state};
    durations.forEach((step, duration) {
      if (next.containsKey(step)) return;
      final clamped = _clamp(duration);
      next[step] = CookTimer(
        configured: clamped,
        remaining: clamped,
        status: CookTimerStatus.idle,
      );
    });
    state = next;
  }

  /// Adjusts [step]'s timer by [delta] (positive or negative). While idle this
  /// changes the duration it counts down from; while running/paused it changes
  /// the time left (running past zero finishes it immediately).
  void adjust(int step, Duration delta) {
    final current = _timerAt(step);
    switch (current.status) {
      case CookTimerStatus.running:
        final next = current.remaining + delta;
        if (next <= Duration.zero) {
          _finish(step);
        } else {
          final clamped = _clampMax(next);
          _set(step, current.copyWith(remaining: clamped));
          // The end time moved, so move its OS notification with it.
          _scheduleTimerNotification(step, clamped);
        }
      case CookTimerStatus.paused:
        _set(
          step,
          current.copyWith(remaining: _clamp(current.remaining + delta)),
        );
      case CookTimerStatus.idle:
      case CookTimerStatus.finished:
        final configured = _clamp(current.configured + delta);
        _set(
          step,
          CookTimer(
            configured: configured,
            remaining: configured,
            status: CookTimerStatus.idle,
          ),
        );
    }
  }

  /// Starts [step]'s countdown, or resumes it from where it was paused, and
  /// schedules a local notification with [notifTitle]/[notifBody] for its end
  /// time so the timer still fires when the app is backgrounded or locked.
  void start(
    int step, {
    required String notifTitle,
    required String notifBody,
  }) {
    final current = _timerAt(step);
    final remaining = switch (current.status) {
      CookTimerStatus.running || CookTimerStatus.paused => current.remaining,
      CookTimerStatus.idle || CookTimerStatus.finished => current.configured,
    };
    _set(
      step,
      current.copyWith(remaining: remaining, status: CookTimerStatus.running),
    );
    _tickers[step]?.cancel();
    _tickers[step] = Timer.periodic(_kTick, (_) => _tick(step));
    _notifText[step] = (notifTitle, notifBody);
    _scheduleTimerNotification(step, remaining);
  }

  /// Pauses [step]'s running countdown, keeping the time left.
  void pause(int step) {
    final current = _timerAt(step);
    if (current.status != CookTimerStatus.running) return;
    _tickers.remove(step)?.cancel();
    _cancelTimerNotification(step);
    _set(step, current.copyWith(status: CookTimerStatus.paused));
  }

  /// Stops [step]'s timer and returns it to idle at its configured duration.
  void reset(int step) {
    _tickers.remove(step)?.cancel();
    _cancelTimerNotification(step);
    final configured = _timerAt(step).configured;
    _set(
      step,
      CookTimer(
        configured: configured,
        remaining: configured,
        status: CookTimerStatus.idle,
      ),
    );
  }

  void _tick(int step) {
    final current = _timerAt(step);
    if (current.status != CookTimerStatus.running) return;
    final next = current.remaining - _kTick;
    if (next <= Duration.zero) {
      _finish(step);
    } else {
      _set(step, current.copyWith(remaining: next));
    }
  }

  void _finish(int step) {
    _tickers.remove(step)?.cancel();
    // Fired in the foreground, so withdraw the scheduled OS backup to avoid a
    // duplicate alert.
    _cancelTimerNotification(step);
    _set(
      step,
      _timerAt(
        step,
      ).copyWith(remaining: Duration.zero, status: CookTimerStatus.finished),
    );
    unawaited(HapticFeedback.heavyImpact());
    unawaited(SystemSound.play(SystemSoundType.alert));
  }

  /// (Re)schedules [step]'s end-of-timer notification for `now + remaining`,
  /// replacing any pending one for the same step.
  void _scheduleTimerNotification(int step, Duration remaining) {
    final text = _notifText[step];
    if (text == null) return;
    unawaited(
      _notifications.scheduleAt(
        id: NotificationIds.cookTimerBase + step,
        when: DateTime.now().add(remaining),
        title: text.$1,
        body: text.$2,
      ),
    );
  }

  void _cancelTimerNotification(int step) =>
      unawaited(_notifications.cancel(NotificationIds.cookTimerBase + step));

  void _set(int step, CookTimer value) => state = {...state, step: value};

  Duration _clamp(Duration value) {
    if (value < _kMinDuration) return _kMinDuration;
    if (value > _kMaxDuration) return _kMaxDuration;
    return value;
  }

  Duration _clampMax(Duration value) =>
      value > _kMaxDuration ? _kMaxDuration : value;

  void _cancelAll() {
    for (final step in _tickers.keys) {
      _cancelTimerNotification(step);
    }
    for (final ticker in _tickers.values) {
      ticker.cancel();
    }
    _tickers.clear();
  }
}
