# Quick Start Guide

Get the CloudBarber app up and running in minutes.

## 📋 Prerequisites

- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Git

## 🚀 5-Minute Setup

### 1. Clone & Install

```bash
git clone https://github.com/carlogennaro1994-tech/cloudbarber-app.git
cd cloudbarber-app
flutter pub get
```

### 2. Generate Required Files (IMPORTANT!)

```bash
# Generate Freezed classes, JSON serialization, and API clients
flutter pub run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n
```

**Note:** This step is REQUIRED. The app won't compile without these generated files.

### 3. Configure API (Optional for testing)

Edit `lib/core/injection_container.dart`:

```dart
baseUrl: 'https://your-api-url.com',  // Change this line
```

### 4. Run the App

```bash
flutter run
```

That's it! 🎉

## 🔧 Common Commands

```bash
# Run the app
flutter run

# Run in release mode (better performance)
flutter run --release

# Hot reload (during development, press 'r' in terminal)

# Hot restart (press 'R' in terminal)

# Format code
flutter format lib/

# Check for issues
flutter analyze

# Run tests
flutter test

# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## 📱 Default Test Credentials

The app currently uses mock authentication. You can log in with any email/password that passes validation:

- **Email:** any valid email format (e.g., `test@example.com`)
- **Password:** at least 6 characters (e.g., `password123`)

## 🎯 Key Features to Test

1. **Authentication Flow**
   - Navigate to Login page (default route)
   - Try registering a new account
   - Log in with credentials
   - Log out from Profile page

2. **Services Catalog**
   - From Profile, click "Services"
   - Expand service cards to see details
   - Note the pricing and duration

3. **Create Booking**
   - From Booking List, click the FAB (+ button)
   - Select one or more services
   - Pick a date and time
   - Add optional notes
   - Create the booking

4. **View Bookings**
   - See list of bookings
   - Click on a booking to see details
   - Try canceling a booking

5. **Profile & Settings**
   - View user profile
   - Navigate through menu options

## 🐛 Troubleshooting

### App won't compile?

```bash
# Clean everything
flutter clean
rm -rf .dart_tool/
rm pubspec.lock

# Reinstall
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### "No freezed.dart files found"?

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### "AppLocalizations not found"?

```bash
flutter gen-l10n
flutter pub get
```

### "Provider not found" errors?

Check that GetIt dependencies are registered in `lib/core/injection_container.dart`.

### API calls failing?

1. Check API base URL in `injection_container.dart`
2. Ensure backend is running
3. Check network permissions in Android/iOS

## 📁 Project Structure

```
cloudbarber-app/
├── lib/
│   ├── app/              # App-level config (theme, routing)
│   ├── core/             # Core utilities (DI, etc.)
│   ├── features/         # Feature modules
│   │   ├── auth/         # Authentication
│   │   ├── booking/      # Booking management
│   │   └── profile/      # User profile
│   ├── l10n/             # Localization files
│   └── main.dart         # App entry point
├── test/                 # Tests
├── android/              # Android config
├── ios/                  # iOS config
└── web/                  # Web config
```

## 📚 Learn More

- **Implementation Details:** See [IMPLEMENTATION.md](IMPLEMENTATION.md)
- **Development Guide:** See [DEVELOPMENT.md](DEVELOPMENT.md)
- **Architecture:** See [ARCHITECTURE.md](ARCHITECTURE.md)
- **Feature Docs:** See [lib/features/README.md](lib/features/README.md)
- **Task Checklist:** See [CHECKLIST.md](CHECKLIST.md)

## 🎨 Customization

### Change Theme Colors

Edit `lib/app/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF2196F3);  // Your color
```

### Change App Name

Edit `lib/l10n/app_en.arb`:

```json
"appName": "Your App Name"
```

Then run: `flutter gen-l10n`

### Change API URL

Edit `lib/core/injection_container.dart`:

```dart
baseUrl: 'https://your-api.com'
```

### Add New Language

1. Create `lib/l10n/app_es.arb` (example for Spanish)
2. Add translations
3. Update `lib/main.dart`:
   ```dart
   supportedLocales: const [
     Locale('en', ''),
     Locale('it', ''),
     Locale('es', ''),  // Add this
   ],
   ```
4. Run: `flutter gen-l10n`

## 🚢 Building for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Google Play)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

```bash
flutter build ios --release
```

Then archive in Xcode.

### Web

```bash
flutter build web --release
```

Output: `build/web/`

## 💡 Pro Tips

1. **Use Hot Reload** - Press `r` during development for instant UI updates
2. **Use DevTools** - `flutter pub global activate devtools` for debugging
3. **Check Logs** - `flutter logs` to see device logs
4. **Profile Performance** - `flutter run --profile` for performance testing
5. **Keep Dependencies Updated** - `flutter pub upgrade` periodically

## 🆘 Need Help?

1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) (if exists)
2. Review [DEVELOPMENT.md](DEVELOPMENT.md) for detailed guides
3. See [CHECKLIST.md](CHECKLIST.md) for implementation status
4. Check inline code comments
5. Review Flutter documentation: https://docs.flutter.dev/

## 🎓 Understanding the Code

### Adding a Feature

1. **Domain Layer First** - Define entities, use cases, repository interface
2. **Data Layer** - Implement repository, create API client
3. **Presentation Layer** - Create pages, wire up providers
4. **Test** - Write tests for your feature

### Example Flow: User Login

```
1. User taps "Login" button
   ↓
2. LoginPage calls authStateProvider.login()
   ↓
3. AuthStateNotifier calls LoginUseCase
   ↓
4. LoginUseCase validates and calls AuthRepository
   ↓
5. AuthRepositoryImpl calls AuthApiClient
   ↓
6. API response converted to domain entity
   ↓
7. State updated, UI rebuilds
   ↓
8. User redirected to Booking List
```

## ✅ Next Steps After Setup

1. ✅ Verify app runs without errors
2. ✅ Test all main features
3. ✅ Connect to your backend API
4. ✅ Customize branding (colors, logo, name)
5. ✅ Add your app icons and splash screens
6. ✅ Configure signing for releases
7. ✅ Add comprehensive tests
8. ✅ Deploy to stores

## 🎉 Success Indicators

You know setup is successful when:
- ✅ App compiles without errors
- ✅ You can navigate between screens
- ✅ Forms validate inputs
- ✅ Buttons and interactions work
- ✅ Theme looks good in light/dark mode
- ✅ No red error screens

Happy coding! 🚀
