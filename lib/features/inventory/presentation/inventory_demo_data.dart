import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_pill.dart';

/// Placeholder inventory data used to render the UI before the real data layer
/// (Supabase-backed providers) exists.
///
/// Everything here is demo content: swapping these lists for provider-backed
/// models is the only change the screens need once persistence lands.
abstract final class InventoryDemoData {
  static const String householdName = 'Lindenhof';
  static const int itemCount = 42;

  /// Counters for the quick-stats strip on the inventory tab.
  static const int expiringCount = 3;
  static const int expiredCount = 1;
  static const int freshCount = 38;

  static const List<StorageLocation> locations = [
    StorageLocation(
      name: 'Kühlschrank',
      icon: Icons.kitchen_outlined,
      color: AppColors.categoryBlue,
      itemCount: 18,
      status: '2 laufen bald ab',
      tone: StatusTone.warning,
    ),
    StorageLocation(
      name: 'Gefrierfach',
      icon: Icons.ac_unit_outlined,
      color: AppColors.categoryCyan,
      itemCount: 5,
    ),
    StorageLocation(
      name: 'Vorrat',
      icon: Icons.inventory_2_outlined,
      color: AppColors.categoryOrange,
      itemCount: 13,
      status: '1 abgelaufen',
      tone: StatusTone.error,
    ),
    StorageLocation(
      name: 'Getränke',
      icon: Icons.local_bar_outlined,
      color: AppColors.categoryPurple,
      itemCount: 6,
    ),
  ];

  /// Items on the home tab's horizontal "expiring soon" rail.
  static const List<InventoryItem> expiringSoon = [
    InventoryItem(
      name: 'Joghurt Natur',
      subtitle: '500 g',
      icon: Icons.breakfast_dining_outlined,
      color: AppColors.categoryBlue,
      trailing: 'in 2 Tagen',
    ),
    InventoryItem(
      name: 'Milch',
      subtitle: '1 l',
      icon: Icons.local_drink_outlined,
      color: AppColors.categoryBlue,
      trailing: 'morgen',
    ),
  ];

  static const List<InventoryItem> recentlyAdded = [
    InventoryItem(
      name: 'Eier',
      subtitle: '10 Stück · Kühlschrank',
      icon: Icons.egg_outlined,
      color: AppColors.categoryBlue,
      trailing: 'Gestern',
    ),
    InventoryItem(
      name: 'Haferdrink',
      subtitle: '1 l · Vorrat',
      icon: Icons.local_drink_outlined,
      color: AppColors.categoryOrange,
      trailing: 'Gestern',
    ),
    InventoryItem(
      name: 'Joghurt Natur',
      subtitle: '500 g · Kühlschrank',
      icon: Icons.breakfast_dining_outlined,
      color: AppColors.categoryBlue,
      trailing: 'Vor 2 Tagen',
    ),
  ];

  /// Contents of the fridge, shown on the location detail page.
  static const List<InventoryItem> fridgeItems = [
    InventoryItem(
      name: 'Milch',
      subtitle: '1 l',
      icon: Icons.local_drink_outlined,
      color: AppColors.categoryBlue,
      trailing: 'in 2 Tagen',
    ),
    InventoryItem(
      name: 'Eier',
      subtitle: '6 Stück',
      icon: Icons.egg_outlined,
      color: AppColors.categoryBlue,
      trailing: 'in 5 Tagen',
    ),
    InventoryItem(
      name: 'Käse',
      subtitle: '200 g',
      icon: Icons.lunch_dining_outlined,
      color: AppColors.categoryBlue,
      trailing: 'in 1 Woche',
    ),
    InventoryItem(
      name: 'Joghurt',
      subtitle: '500 g',
      icon: Icons.breakfast_dining_outlined,
      color: AppColors.categoryBlue,
      trailing: 'in 1 Woche',
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
    required this.color,
    required this.itemCount,
    this.status,
    this.tone,
  });

  final String name;
  final IconData icon;

  /// Category accent used for the tinted icon tile.
  final Color color;

  final int itemCount;

  /// Status line under the count; when null the location shows "Alles frisch".
  final String? status;

  /// Tone of the status badge; null renders the green "fresh" badge.
  final StatusTone? tone;
}

/// A single inventory list row (recently added, expiring, etc.).
class InventoryItem {
  const InventoryItem({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.trailing,
  });

  final String name;
  final String subtitle;
  final IconData icon;

  /// Category accent used for the tinted icon tile.
  final Color color;

  /// Trailing metadata such as a relative date or expiry.
  final String? trailing;
}
