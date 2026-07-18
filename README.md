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

# Run on a simulator or connected device (see "Configuration & secrets" below)
fvm flutter run --dart-define-from-file=config/app_config.json
```

> No FVM? A system-wide Flutter matching the version in `.fvmrc` works too — just drop the `fvm` prefix.

### Configuration & secrets

Configuration (Supabase URL, anon key, Open Food Facts User-Agent) is injected
at build time via `--dart-define-from-file` and read through
[`AppConfig`](lib/core/config/app_config.dart). Real values live in a
git-ignored `config/app_config.json`; only the `*.example.json` template is
committed. See [ADR-0008](docs/adr/0008-secrets-management.md) for the full
rationale.

```bash
# 1. Create your local config from the template, then fill in the values
cp config/app_config.example.json config/app_config.json

# 2. Enable the secret-scanning pre-commit hook (once per clone)
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit          # macOS/Linux only

# 3. Install gitleaks so the hook can run
#    macOS:  brew install gitleaks
#    Windows: scoop install gitleaks   (or winget install gitleaks.gitleaks)
```

Run with the config injected — the "Zaiko (dev)" launch config in
`.vscode/launch.json` does this automatically, or from the CLI:

```bash
fvm flutter run --dart-define-from-file=config/app_config.json
```

Secrets are guarded on three layers: `.gitignore`, the gitleaks pre-commit
hook, and a required `gitleaks` CI check on `main`. The Supabase `service_role`
key must **never** be placed in the app or repo — only the anon key ships
(access is gated by row-level security).

### Quality checks

```bash
fvm dart format .          # Format
fvm flutter analyze        # Static analysis
fvm flutter test           # Run all tests
fvm flutter test --coverage  # ...with coverage (coverage/lcov.info)
```

CI runs the same checks plus a debug Android build on every pull request — see [.github/workflows/ci.yml](.github/workflows/ci.yml).

### Code generation

Models and providers are generated with `build_runner` (freezed +
json_serializable + riverpod_generator). While developing, run the watcher so
`*.freezed.dart` / `*.g.dart` files regenerate on save:

```bash
fvm dart run build_runner watch   # regenerate on change
fvm dart run build_runner build   # one-off build
```

> Conflict deletion is the default in the pinned `build_runner`, so the old
> `--delete-conflicting-outputs` flag is no longer needed.

The generated files **are committed** so the repository stays self-contained
(clone and run without a codegen step, and diffs stay reviewable). See
[ADR-0009](docs/adr/0009-code-generation.md) for the rationale.

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
