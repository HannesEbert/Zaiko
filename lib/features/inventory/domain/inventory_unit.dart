/// The fixed set of units an inventory item's quantity can be measured in.
///
/// The app owns this enum; `inventory_items.unit` stores the [key] as plain
/// text (deliberately unconstrained in the schema so the enum can grow without
/// a migration). [InventoryItem.unit] stays a nullable `String` — legacy or
/// unitless rows map to a null [InventoryUnit] via [fromKey].
enum InventoryUnit {
  gram('g'),
  kilogram('kg'),
  milliliter('ml'),
  liter('l'),
  piece('piece'),
  package('package');

  const InventoryUnit(this.key);

  /// The stable string persisted in `inventory_items.unit`.
  final String key;

  /// The [InventoryUnit] for a stored [key], or null when it is null, empty or
  /// unrecognized — so an unexpected value never crashes the picker.
  static InventoryUnit? fromKey(String? key) {
    if (key == null || key.isEmpty) return null;
    for (final unit in values) {
      if (unit.key == key) return unit;
    }
    return null;
  }
}
