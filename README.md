# 🍱 Zaiko — Smart Food Inventory Tracker

> **在庫 (Zaiko)** — Japanese for "inventory". Track what you have, waste less, shop smarter.

Zaiko is a mobile app built with Flutter for managing your household food inventory. Keep track of everything in your fridge and pantry, get notified before food expires, and coordinate shopping lists with your household — all in one place.

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

_Screenshots follow as soon as there is UI worth showing._

---

## 🏗️ Architecture

Feature-first structure, layered inside each feature, with Riverpod as the backbone for state and dependency injection:

| Concern | Decision |
|---|---|
| **Structure** | Feature-first (`lib/features/<feature>/`), plus `lib/core/` & `lib/shared/` |
| **State Management & DI** | [Riverpod](https://riverpod.dev) |
| **Navigation** | [go_router](https://pub.dev/packages/go_router) — deep-link ready |
| **Backend & Sync** | [Supabase](https://supabase.com) (planned, added with the first backend feature) |
| **Local Database** | Deferred until offline support — see ADR-0007 |

Every decision is documented with alternatives and reasoning in [docs/architecture.md](docs/architecture.md) and the [ADRs](docs/adr/README.md).

```
lib/
├── main.dart        # Entry point
├── app.dart         # Root widget: theming + routing
├── core/            # Theme, router, constants — feature-agnostic
├── shared/          # Reusable widgets
└── features/        # One folder per feature (inventory, shopping list, …)
```

---

## 🚀 Getting Started

### Prerequisites

- [FVM](https://fvm.app) (Flutter Version Management) — the Flutter version is pinned in [.fvmrc](.fvmrc)
- For iOS builds: macOS with Xcode 15+
- For Android builds: Android SDK (e.g. via Android Studio)

### Installation

```bash
# Clone the repository
git clone https://github.com/HannesEbert/Zaiko.git
cd Zaiko

# Install the pinned Flutter version
fvm install

# Install dependencies
fvm flutter pub get

# Run on a simulator or connected device
fvm flutter run
```

> No FVM? A system-wide Flutter matching the version in `.fvmrc` works too — just drop the `fvm` prefix.

No environment variables are needed yet. Once Supabase lands, configuration will come from `--dart-define` / `.env` (never committed) and be documented here.

### Quality checks

```bash
fvm dart format .          # Format
fvm flutter analyze        # Static analysis
fvm flutter test           # Run all tests
fvm flutter test --coverage  # ...with coverage (coverage/lcov.info)
```

CI runs the same checks plus a debug Android build on every pull request — see [.github/workflows/ci.yml](.github/workflows/ci.yml).

---

## 📚 Documentation

- [Architecture Overview](docs/architecture.md)
- [Architecture Decision Records](docs/adr/README.md)

Database schema and design system docs are added once those parts are designed.

---

## 🤝 Contributing

This is currently a personal portfolio project — feedback and suggestions are welcome via [issues](../../issues). The workflow, also for my future self:

- **Branches:** `feature/<topic>`, `fix/<topic>`, `chore/<topic>` — branched off `main`
- **Commits:** short, imperative subject line ("Add expiry sorting"), body explains *why* when it isn't obvious
- **PRs:** `main` is protected — every change goes through a pull request with green CI (format, analyze, test, build)

## 👨‍💻 Author

**Hannes Ebert**

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
