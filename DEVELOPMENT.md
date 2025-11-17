# Development Guide

This guide covers development workflows, code generation, and common tasks.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- Xcode (for iOS development on macOS)

### Initial Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/carlogennaro1994-tech/cloudbarber-app.git
   cd cloudbarber-app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate code (required):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   
   This will generate:
   - Freezed classes (*.freezed.dart)
   - JSON serialization (*.g.dart)
   - Retrofit API clients (*.g.dart)

4. **Generate localizations:**
   ```bash
   flutter gen-l10n
   ```

5. **Verify setup:**
   ```bash
   flutter doctor -v
   ```

## 🔨 Code Generation

### Build Runner

The project uses several code generators:

- **Freezed** - For immutable data classes
- **json_serializable** - For JSON serialization
- **Retrofit** - For API clients

#### Generate all code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Watch mode (regenerates on file changes):
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

#### Clean generated files:
```bash
flutter pub run build_runner clean
```

### What Gets Generated

After running build_runner, you'll see new files:

```
lib/features/booking/domain/entities/
├── booking.dart
├── booking.freezed.dart      # Generated
├── booking.g.dart             # Generated
├── service.dart
├── service.freezed.dart       # Generated
└── service.g.dart             # Generated
```

### Adding a New Entity

1. Create the entity file:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_entity.freezed.dart';
part 'my_entity.g.dart';

@freezed
class MyEntity with _$MyEntity {
  const factory MyEntity({
    required String id,
    required String name,
  }) = _MyEntity;

  factory MyEntity.fromJson(Map<String, dynamic> json) => 
      _$MyEntityFromJson(json);
}
```

2. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🧪 Testing

### Run all tests:
```bash
flutter test
```

### Run specific test file:
```bash
flutter test test/features/booking/domain/usecases/create_booking_use_case_test.dart
```

### Run tests with coverage:
```bash
flutter test --coverage
```

### View coverage report:
```bash
# Install lcov first (on macOS):
brew install lcov

# Generate HTML report:
genhtml coverage/lcov.info -o coverage/html

# Open in browser:
open coverage/html/index.html
```

## 🏗️ Building

### Development Build (Android):
```bash
flutter run
```

### Release Build (Android):
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Or build app bundle for Google Play:
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS Build:
```bash
flutter build ios --release
```

### Web Build:
```bash
flutter build web --release
# Output: build/web/
```

## 🎨 Working with UI

### Hot Reload

During development, use hot reload to see changes instantly:
- Press `r` in the terminal
- Or press `Cmd/Ctrl + S` in your IDE

### Hot Restart

For more significant changes:
- Press `R` in the terminal
- Or press `Cmd/Ctrl + Shift + R` in your IDE

### Material Design 3

The app uses Material Design 3. Key widgets:
- `Card` - For content containers
- `FilledButton` / `ElevatedButton` - For primary actions
- `ListTile` - For list items
- `NavigationBar` - For bottom navigation

Theme is configured in `lib/app/app_theme.dart`.

## 🌐 Localization

### Adding a New Translation

1. Open `lib/l10n/app_en.arb`:
```json
{
  "myNewKey": "My New Text",
  "@myNewKey": {
    "description": "Description of what this text is for"
  }
}
```

2. Add the same key to `lib/l10n/app_it.arb`:
```json
{
  "myNewKey": "Il Mio Nuovo Testo",
  "@myNewKey": {
    "description": "Descrizione di cosa serve questo testo"
  }
}
```

3. Generate localization:
```bash
flutter gen-l10n
```

4. Use in code:
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.myNewKey);
```

### Adding a New Language

1. Create `lib/l10n/app_es.arb` (for Spanish)
2. Add all translations
3. Update `lib/main.dart`:
```dart
supportedLocales: const [
  Locale('en', ''),
  Locale('it', ''),
  Locale('es', ''),  // Add this
],
```

## 🔧 Common Development Tasks

### Adding a New Feature

1. **Create feature structure:**
```bash
mkdir -p lib/features/my_feature/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{pages,widgets,providers}}
```

2. **Create domain layer:**
   - Define entities
   - Define repository interface
   - Create use cases

3. **Create data layer:**
   - Create data models
   - Implement repository
   - Create API client (if needed)

4. **Create presentation layer:**
   - Create pages
   - Create providers
   - Wire up with routing

### Adding a New API Endpoint

1. **Update API client:**
```dart
@GET('/my-endpoint')
Future<MyModel> getMyData(@Query('param') String param);
```

2. **Update repository:**
```dart
Future<MyEntity> getMyData(String param) async {
  final model = await apiClient.getMyData(param);
  return model.toEntity();
}
```

3. **Create/update use case:**
```dart
class GetMyDataUseCase {
  final MyRepository repository;
  
  Future<MyEntity> call(String param) async {
    return await repository.getMyData(param);
  }
}
```

4. **Create provider:**
```dart
final myDataProvider = FutureProvider.family<MyEntity, String>(
  (ref, param) async {
    final useCase = ref.watch(getMyDataUseCaseProvider);
    return await useCase(param);
  },
);
```

### Debugging

#### Enable verbose logging:
```bash
flutter run -v
```

#### Check for issues:
```bash
flutter analyze
```

#### Format code:
```bash
flutter format lib/
```

#### Update dependencies:
```bash
flutter pub upgrade
flutter pub outdated
```

## 🔐 Environment Configuration

### API Base URL

Update in `lib/core/injection_container.dart`:
```dart
final dio = Dio(
  BaseOptions(
    baseUrl: 'https://your-api-url.com',  // Change this
    // ...
  ),
);
```

### Using Environment Variables

1. Create `.env` file (add to .gitignore):
```
API_BASE_URL=https://api.cloudbarber.com
API_KEY=your-api-key
```

2. Install package:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

3. Load in `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}
```

4. Use in code:
```dart
final apiUrl = dotenv.env['API_BASE_URL'];
```

## 📱 Platform-Specific Configuration

### Android

#### Update package name:
`android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.yourcompany.cloudbarber"
}
```

#### Update app name:
`android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="CloudBarber"
```

### iOS

#### Update bundle identifier:
Open `ios/Runner.xcworkspace` in Xcode and update in project settings.

#### Update app name:
`ios/Runner/Info.plist`:
```xml
<key>CFBundleName</key>
<string>CloudBarber</string>
```

## 🚢 Deployment

### Android (Google Play)

1. Create signing key
2. Configure `android/key.properties`
3. Build release:
```bash
flutter build appbundle --release
```

### iOS (App Store)

1. Configure signing in Xcode
2. Build release:
```bash
flutter build ios --release
```
3. Archive and upload via Xcode

### Web

1. Build:
```bash
flutter build web --release
```

2. Deploy to hosting (Firebase, Netlify, etc.)

## 🐛 Troubleshooting

### "No *.freezed.dart file found"
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### "Localizations not found"
```bash
flutter gen-l10n
flutter pub get
```

### "Dio/Retrofit errors"
Make sure API client is registered in `injection_container.dart`.

### "Provider errors"
Check that all dependencies are properly injected in GetIt.

### Clear everything and rebuild:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Material Design 3](https://m3.material.io/)

## 🤝 Code Style

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart).

### Key conventions:
- Use `camelCase` for variable and function names
- Use `PascalCase` for class names
- Use `snake_case` for file names
- Max line length: 80 characters (configurable)
- Always use `const` constructors when possible
- Prefer `final` over `var` when possible

### Linting

Configured in `analysis_options.yaml`. Run:
```bash
flutter analyze
```

## 💡 Tips

1. **Use Riverpod DevTools** - Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  riverpod_lint: ^2.3.7
```

2. **Use Flutter DevTools** - For debugging:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

3. **Hot reload tips:**
   - Works for UI changes
   - Doesn't work for: adding/removing files, changing state logic
   - Use hot restart for structural changes

4. **Performance profiling:**
```bash
flutter run --profile
```

5. **Build times:**
   - Use `flutter run` for development (JIT compilation)
   - Use `flutter run --release` for performance testing (AOT compilation)
