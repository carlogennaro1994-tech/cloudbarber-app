# CloudBarber Project Structure

## Overview
CloudBarber follows a **feature-based clean architecture** pattern with clear separation of concerns across three layers:

## Directory Structure

```
cloudbarber-app/
│
├── android/                    # Android platform configuration
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── kotlin/com/cloudbarber/app/
│   │   │       └── MainActivity.kt
│   │   └── build.gradle
│   └── settings.gradle
│
├── ios/                        # iOS platform configuration
│   └── Runner/
│       ├── AppDelegate.swift
│       └── Info.plist
│
├── web/                        # Web platform configuration
│   ├── index.html
│   └── manifest.json
│
├── assets/                     # Static resources
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── lib/                        # Main application code
│   ├── main.dart              # Application entry point
│   │
│   ├── app/                   # Application-level configuration
│   │   ├── app_theme.dart    # Theme definitions (dark/light)
│   │   └── app_router.dart   # Navigation configuration
│   │
│   ├── core/                  # Core shared functionality
│   │   └── injection_container.dart  # Dependency injection setup
│   │
│   ├── l10n/                  # Localization files
│   │   ├── app_en.arb        # English translations
│   │   └── app_it.arb        # Italian translations
│   │
│   └── features/              # Feature modules
│       │
│       ├── auth/              # Authentication feature
│       │   ├── data/          # Data layer
│       │   │   └── README.md # Data sources, repositories, models
│       │   ├── domain/        # Domain layer
│       │   │   └── README.md # Entities, use cases, interfaces
│       │   └── presentation/  # Presentation layer
│       │       └── pages/
│       │           ├── login_page.dart
│       │           └── register_page.dart
│       │
│       ├── booking/           # Booking management feature
│       │   ├── data/
│       │   │   └── README.md
│       │   ├── domain/
│       │   │   └── README.md
│       │   └── presentation/
│       │       └── pages/
│       │           ├── booking_list_page.dart
│       │           └── booking_detail_page.dart
│       │
│       └── profile/           # User profile feature
│           ├── data/
│           │   └── README.md
│           ├── domain/
│           │   └── README.md
│           └── presentation/
│               └── pages/
│                   └── profile_page.dart
│
├── test/                      # Unit and widget tests
│
├── .gitignore                 # Git ignore rules
├── analysis_options.yaml      # Dart analyzer configuration
├── l10n.yaml                  # Localization configuration
├── pubspec.yaml               # Dependencies and assets
└── README.md                  # Project documentation
```

## Architecture Layers

### 1. Presentation Layer
- **Location**: `lib/features/*/presentation/`
- **Responsibilities**: 
  - UI components (pages, widgets)
  - State management with Riverpod
  - User interaction handling
- **Example**: Login page, Booking list

### 2. Domain Layer
- **Location**: `lib/features/*/domain/`
- **Responsibilities**:
  - Business logic
  - Entities (pure Dart objects)
  - Use cases
  - Repository interfaces
- **Example**: LoginUseCase, BookingEntity

### 3. Data Layer
- **Location**: `lib/features/*/data/`
- **Responsibilities**:
  - Data sources (remote API, local DB)
  - Repository implementations
  - Data models and DTOs
  - API clients
- **Example**: AuthRepository, BookingRemoteDataSource

## Key Technologies

### State Management
- **Riverpod**: Modern, compile-safe state management
- **Provider Scope**: Application-wide state container

### Navigation
- **GoRouter**: Declarative routing with deep linking support
- **Routes**: Defined in `app/app_router.dart`

### Dependency Injection
- **GetIt**: Service locator
- **Injectable**: Code generation for DI
- **Setup**: `core/injection_container.dart`

### Localization
- **Flutter i18n**: Built-in internationalization
- **Supported Languages**: English (en), Italian (it)
- **ARB Files**: JSON-like format for translations

### Theme
- **Material 3**: Latest Material Design
- **Dark Theme**: Default theme mode
- **Custom Colors**: Brand colors defined in `app_theme.dart`

## Data Flow

```
User Action (Presentation)
    ↓
Use Case (Domain)
    ↓
Repository Interface (Domain)
    ↓
Repository Implementation (Data)
    ↓
Data Source (Data)
    ↓
API / Local Storage
```

## Feature Module Structure

Each feature follows this structure:

```
feature_name/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── pages/
    ├── widgets/
    └── providers/
```

## Next Steps

1. **Implement Use Cases**: Add business logic in domain layer
2. **Create Data Sources**: Implement API clients and local storage
3. **Add State Management**: Create Riverpod providers
4. **Implement Repositories**: Connect data sources to domain
5. **Add Tests**: Unit tests for use cases, widget tests for UI
6. **Code Generation**: Run build_runner for generated code

## Commands

### Generate Localization
```bash
flutter gen-l10n
```

### Generate Code (Freezed, JSON, etc.)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run Tests
```bash
flutter test
```

### Run App
```bash
flutter run
```
