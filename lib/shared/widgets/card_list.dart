import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'zaiko_card.dart';

/// Wraps a set of rows in a [ZaikoCard] with thin dividers between them — the
/// grouped-list pattern used for inventory lists, settings and shopping items.
class CardList extends StatelessWidget {
  const CardList({required this.children, this.opacity = 1, super.key});

  final List<Widget> children;

  /// Optional whole-card opacity (e.g. the dimmed "done" shopping section).
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      height: 1,
      thickness: 1,
      color: context.colors.divider,
    );

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i != children.length - 1) rows.add(divider);
    }

    final card = ZaikoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows,
      ),
    );

    return opacity == 1 ? card : Opacity(opacity: opacity, child: card);
  }
}
