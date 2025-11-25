# CloudBarber App

CloudBarber is a premium Flutter application for barber shop management, built with a modern architecture and best practices.

## 🏗️ Architecture

This project follows a **feature-based clean architecture** with clear separation of concerns:

- **Presentation Layer**: UI components, pages, and state management
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Data sources, repositories, and models

### Tech Stack

- **State Management**: Riverpod
- **Routing**: GoRouter
- **Dependency Injection**: GetIt + Injectable
- **Localization**: Flutter i18n (IT/EN)
- **Networking**: Dio + Retrofit
- **Local Storage**: SharedPreferences + FlutterSecureStorage
- **Code Generation**: Freezed + JsonSerializable
- **UI**: Material Design 3 with custom dark theme

## 📁 Project Structure

```
lib/
├── app/                    # Application-level configuration
│   ├── app_theme.dart     # Theme configuration (light/dark)
│   └── app_router.dart    # Navigation routes with GoRouter
├── core/                   # Core functionality
│   └── injection_container.dart  # Dependency injection setup
├── features/               # Feature modules
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Data sources, repositories
│   │   ├── domain/        # Entities, use cases
│   │   └── presentation/  # UI pages and widgets
│   ├── booking/           # Booking management feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── profile/           # User profile feature
│       ├── data/
│       ├── domain/
│       └── presentation/
├── l10n/                   # Localization files
│   ├── app_en.arb         # English translations
│   └── app_it.arb         # Italian translations
└── main.dart              # Application entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/carlogennaro1994-tech/cloudbarber-app.git
   cd cloudbarber-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code (for localization, routing, etc.):
   ```bash
   flutter gen-l10n
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Code Generation

This project uses code generation for various purposes. Run the following command when needed:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎨 Features

- **Authentication**: Login and registration flows
- **Booking Management**: Create, view, and manage bookings
- **User Profile**: View and edit user information
- **Dark Theme**: Beautiful dark theme by default
- **Multilingual**: Support for Italian and English
- **Responsive**: Works on mobile, tablet, and web

## 🌐 Localization

The app supports multiple languages:
- 🇬🇧 English (en)
- 🇮🇹 Italian (it)

To add a new language:
1. Create a new ARB file in `lib/l10n/` (e.g., `app_es.arb`)
2. Add translations
3. Run `flutter gen-l10n`
4. Add the locale to `supportedLocales` in `main.dart`

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 📦 Building

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔧 Configuration

### API Base URL

Update the API base URL in `lib/core/injection_container.dart`:
```dart
baseUrl: 'https://api.cloudbarber.com'
```

### Environment Variables

For sensitive data, use environment variables or a `.env` file (not included in version control).

## 📝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [README.md](./README.md) | Project overview and quick start |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Application architecture details |
| [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) | Database schema, entities, and relationships |
| [SECURITY_RULES.md](./SECURITY_RULES.md) | Security rules, validation, and access control |
| [DEVELOPMENT.md](./DEVELOPMENT.md) | Development setup and workflow |
| [IMPLEMENTATION.md](./IMPLEMENTATION.md) | Implementation summary |
| [CHECKLIST.md](./CHECKLIST.md) | Feature implementation tracking |

## 📄 License

This project is proprietary software. All rights reserved.

## 👥 Contact

For questions or support, please contact the development team.
