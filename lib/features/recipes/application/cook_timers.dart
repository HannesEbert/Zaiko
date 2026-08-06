import 'dart:async';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
          _set(step, current.copyWith(remaining: _clampMax(next)));
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

  /// Starts [step]'s countdown, or resumes it from where it was paused.
  void start(int step) {
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
  }

  /// Pauses [step]'s running countdown, keeping the time left.
  void pause(int step) {
    final current = _timerAt(step);
    if (current.status != CookTimerStatus.running) return;
    _tickers.remove(step)?.cancel();
    _set(step, current.copyWith(status: CookTimerStatus.paused));
  }

  /// Stops [step]'s timer and returns it to idle at its configured duration.
  void reset(int step) {
    _tickers.remove(step)?.cancel();
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
    _set(
      step,
      _timerAt(
        step,
      ).copyWith(remaining: Duration.zero, status: CookTimerStatus.finished),
    );
    unawaited(HapticFeedback.heavyImpact());
    unawaited(SystemSound.play(SystemSoundType.alert));
  }

  void _set(int step, CookTimer value) => state = {...state, step: value};

  Duration _clamp(Duration value) {
    if (value < _kMinDuration) return _kMinDuration;
    if (value > _kMaxDuration) return _kMaxDuration;
    return value;
  }

  Duration _clampMax(Duration value) =>
      value > _kMaxDuration ? _kMaxDuration : value;

  void _cancelAll() {
    for (final ticker in _tickers.values) {
      ticker.cancel();
    }
    _tickers.clear();
  }
}
