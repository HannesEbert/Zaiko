# 🍱 Saiko — Smart Food Inventory Tracker

> **在庫 (Zaiko)** — Japanese for "inventory". Track what you have, waste less, shop smarter.

Zaiko is an iOS app built with Flutter for managing your household food inventory. Keep track of everything in your fridge and pantry, get notified before food expires, and coordinate shopping lists with your household — all in one place.

---

## ✨ Core Features

- 🍎 **Food Inventory Tracking** — Log all groceries at home with quantities and expiration dates
- ⏰ **Expiration Management** — Sort items by best-before date and always know what to use up next
- 📝 **Collaborative Shopping Lists** — Create and manage shared shopping lists with your household
- 🔔 **Smart Notifications** — Get notified before items expire, so nothing goes to waste

### 🚧 Coming Soon

- 🤖 **AI-Powered Categorization** — Automatic sorting of items into categories (frozen, chilled, pantry, …)
- 📊 **Usage Analytics & Reports** — Insights into consumption habits and food waste
- 🍳 **Recipe Integration** — Add recipes and push missing ingredients straight to your shopping list
- 🤝 **Inventory Export API** — Share your fridge contents with AI assistants for recipe suggestions

---

## 🏗️ Architecture

| Layer | Technology |
|---|---|
| **Frontend** | Flutter 3.x (iOS — Android planned) |
| **State Management** | _TBD — evaluating [Riverpod](https://riverpod.dev) (recommended), Provider, or Bloc_ |
| **Local Database** | _TBD — evaluating [Isar](https://isar.dev) (recommended), Drift, or Hive_ |
| **Sync & Backend** | [Supabase](https://supabase.com) _(alternative: Firebase)_ |
| **Notifications** | flutter_local_notifications |

> **Why Supabase?** Open-source, PostgreSQL-based, great Flutter SDK, and built-in auth + realtime sync — a strong fit for collaborative shopping lists.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) 3.13+
- Xcode 15+ (for iOS builds)
- iOS 13+ device or simulator
- VS Code with the Flutter extension (recommended)

### Installation

```bash
# Clone the repository
git clone https://github.com/hannesebert/zaiko.git
cd zaiko

# Install dependencies
flutter pub get

# Run on iOS simulator or connected device
flutter run
```

### Running Tests

```bash
flutter test
```

---

## 📚 Documentation

- [Architecture Overview](docs/architecture.md)
- [Database Schema](docs/database-schema.md)
- [Design System](docs/design-system.md)

_Documentation is a work in progress and grows alongside the project._

---

## 🤝 Contributing

This is currently a personal portfolio project. Feedback and suggestions are welcome — feel free to [open an issue](../../issues).

## 👨‍💻 Author

**Hannes Ebert**

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
