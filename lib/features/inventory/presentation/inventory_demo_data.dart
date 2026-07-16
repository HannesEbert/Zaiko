import 'package:flutter/material.dart';

import '../../../shared/widgets/status_pill.dart';

/// Placeholder inventory data used to render the UI before the real data layer
/// (Isar collections + Riverpod providers) exists.
///
/// Everything here is demo content: swapping these lists for provider-backed
/// models is the only change the screens need once persistence lands.
abstract final class InventoryDemoData {
  static const String householdName = 'Lindenhof';
  static const int itemCount = 42;

  static const List<StorageLocation> locations = [
    StorageLocation(
      name: 'Kühlschrank',
      icon: Icons.kitchen_outlined,
      itemCount: 18,
      status: '2 laufen bald ab',
      tone: StatusTone.warning,
    ),
    StorageLocation(
      name: 'Gefrierfach',
      icon: Icons.ac_unit_outlined,
      itemCount: 5,
    ),
    StorageLocation(
      name: 'Vorrat',
      icon: Icons.inventory_2_outlined,
      itemCount: 13,
      status: '1 abgelaufen',
      tone: StatusTone.error,
    ),
    StorageLocation(
      name: 'Getränke',
      icon: Icons.local_bar_outlined,
      itemCount: 6,
    ),
  ];

  static const List<InventoryItem> recentlyAdded = [
    InventoryItem(
      name: 'Eier',
      subtitle: '10 Stück · Kühlschrank',
      icon: Icons.egg_outlined,
      trailing: 'Gestern',
    ),
    InventoryItem(
      name: 'Haferdrink',
      subtitle: '1 l · Vorrat',
      icon: Icons.local_drink_outlined,
      trailing: 'Gestern',
    ),
  ];

  static const List<String> recentlyUsedProducts = [
    'Bio Vollmilch',
    'Eier',
    'Haferdrink',
  ];
}

/// A storage location card on the inventory grid.
class StorageLocation {
  const StorageLocation({
    required this.name,
    required this.icon,
    required this.itemCount,
    this.status,
    this.tone,
  });

  final String name;
  final IconData icon;
  final int itemCount;

  /// Status line under the count; when null the location shows "Alles frisch".
  final String? status;

  /// Tone of the status dot/text; null renders a neutral "fresh" line.
  final StatusTone? tone;
}

/// A single inventory list row (recently added, expiring, etc.).
class InventoryItem {
  const InventoryItem({
    required this.name,
    required this.subtitle,
    required this.icon,
    this.trailing,
  });

  final String name;
  final String subtitle;
  final IconData icon;

  /// Trailing metadata such as a relative date.
  final String? trailing;
}
