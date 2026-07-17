import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// The app's standard elevated surface: a near-black rounded container with a
/// hairline border, matching the design's flat card style.
///
/// Used for every card, grouped list and sheet in the design so their
/// appearance stays consistent. Pass [onTap] to make the whole card tappable.
class ZaikoCard extends StatelessWidget {
  const ZaikoCard({
    required this.child,
    this.padding,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppRadius.lg);

    final content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: radius,
        border: Border.all(color: colors.borderSubtle),
      ),
      child: onTap == null
          ? ClipRRect(borderRadius: radius, child: content)
          : Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                child: content,
              ),
            ),
    );
  }
}
