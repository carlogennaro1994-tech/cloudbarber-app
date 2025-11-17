# Contributing to CloudBarber

Thank you for your interest in contributing to CloudBarber! This document provides guidelines and best practices for development.

## Development Setup

### Prerequisites
- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Git
- IDE (VS Code or Android Studio recommended)

### Initial Setup
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter gen-l10n` to generate localization files
4. Run `flutter pub run build_runner build` for code generation

## Code Style

### Dart Style Guide
- Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` to check for issues
- Run `dart format .` to format code

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE`
- **Private members**: prefix with `_`

## Architecture Guidelines

### Clean Architecture Principles
1. **Separation of Concerns**: Keep layers independent
2. **Dependency Rule**: Inner layers should not depend on outer layers
3. **Testability**: Write testable code with dependency injection

### Feature Development

When adding a new feature, follow this structure:

```
feature_name/
├── data/
│   ├── datasources/
│   │   ├── feature_remote_datasource.dart
│   │   └── feature_local_datasource.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       ├── get_feature.dart
│       ├── create_feature.dart
│       └── update_feature.dart
└── presentation/
    ├── pages/
    │   ├── feature_page.dart
    │   └── feature_detail_page.dart
    ├── widgets/
    │   └── feature_widget.dart
    └── providers/
        └── feature_provider.dart
```

### State Management with Riverpod

```dart
// Provider example
final featureProvider = StateNotifierProvider<FeatureNotifier, FeatureState>(
  (ref) => FeatureNotifier(),
);

// Consumer example
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureProvider);
    return Text(state.data);
  }
}
```

### Routing with GoRouter

Add routes in `lib/app/app_router.dart`:

```dart
GoRoute(
  path: '/feature',
  name: 'feature',
  builder: (context, state) => const FeaturePage(),
),
```

## Testing

### Test Structure
```
test/
├── features/
│   └── feature_name/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── core/
```

### Writing Tests

#### Unit Tests (Use Cases)
```dart
void main() {
  late FeatureUseCase useCase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    useCase = FeatureUseCase(mockRepository);
  });

  test('should return data when repository call is successful', () async {
    // Arrange
    when(mockRepository.getData()).thenAnswer((_) async => Right(data));
    
    // Act
    final result = await useCase.call();
    
    // Assert
    expect(result, Right(data));
  });
}
```

#### Widget Tests
```dart
void main() {
  testWidgets('should display text when loaded', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: MyWidget()),
      ),
    );
    
    expect(find.text('Hello'), findsOneWidget);
  });
}
```

## Localization

### Adding Translations

1. Add keys to both ARB files:

**lib/l10n/app_en.arb**
```json
{
  "newFeature": "New Feature",
  "@newFeature": {
    "description": "Description of the feature"
  }
}
```

**lib/l10n/app_it.arb**
```json
{
  "newFeature": "Nuova Funzionalità"
}
```

2. Run `flutter gen-l10n`

3. Use in code:
```dart
Text(AppLocalizations.of(context)!.newFeature)
```

## Git Workflow

### Branch Naming
- `feature/feature-name` - New features
- `bugfix/bug-description` - Bug fixes
- `hotfix/critical-fix` - Critical production fixes
- `refactor/what-changed` - Code refactoring

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add user authentication
fix: resolve booking date picker issue
docs: update README with setup instructions
style: format code according to dart guidelines
refactor: improve repository pattern implementation
test: add unit tests for booking use case
chore: update dependencies
```

### Pull Request Process
1. Create a feature branch
2. Make your changes
3. Write/update tests
4. Run `flutter analyze` and `flutter test`
5. Update documentation if needed
6. Submit PR with clear description
7. Wait for code review
8. Address feedback
9. Merge after approval

## Code Generation

### When to Run Build Runner
- After creating/modifying Freezed classes
- After adding/updating JSON serialization
- After changing Injectable annotations
- After modifying Riverpod generators

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch Mode (Development)
```bash
flutter pub run build_runner watch
```

## Common Patterns

### Error Handling
```dart
try {
  final result = await repository.getData();
  return Right(result);
} catch (e) {
  return Left(ServerFailure());
}
```

### Dependency Injection
```dart
@injectable
class FeatureRepository implements IFeatureRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  
  FeatureRepository(this.remoteDataSource, this.localDataSource);
}
```

### Freezed Models
```dart
@freezed
class Feature with _$Feature {
  const factory Feature({
    required String id,
    required String name,
  }) = _Feature;
  
  factory Feature.fromJson(Map<String, dynamic> json) => 
    _$FeatureFromJson(json);
}
```

## Best Practices

### Do's ✅
- Write tests for all business logic
- Use const constructors where possible
- Follow the single responsibility principle
- Keep widgets small and focused
- Use meaningful variable names
- Document complex logic
- Handle errors gracefully
- Use Riverpod for state management
- Follow clean architecture principles

### Don'ts ❌
- Don't mix business logic with UI
- Don't hardcode strings (use localization)
- Don't ignore analyzer warnings
- Don't commit generated files (*.g.dart, *.freezed.dart)
- Don't skip tests
- Don't use print() (use logger instead)
- Don't expose sensitive data in logs

## Performance Tips

1. **Use const widgets** when possible
2. **Optimize list rendering** with `ListView.builder`
3. **Cache images** and assets
4. **Lazy load** data when appropriate
5. **Profile** your app regularly
6. **Minimize rebuilds** with proper state management

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## Questions?

If you have questions, please:
1. Check existing documentation
2. Search closed issues
3. Open a new issue with the question label

Happy coding! 🚀
