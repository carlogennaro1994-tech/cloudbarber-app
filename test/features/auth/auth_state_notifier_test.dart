import 'package:cloudbarber/features/auth/domain/entities/user.dart';
import 'package:cloudbarber/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:cloudbarber/features/auth/domain/usecases/login_use_case.dart';
import 'package:cloudbarber/features/auth/domain/usecases/logout_use_case.dart';
import 'package:cloudbarber/features/auth/domain/usecases/register_use_case.dart';
import 'package:cloudbarber/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockRegisterUseCase extends Mock implements RegisterUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

class _MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  late _MockLoginUseCase login;
  late _MockRegisterUseCase register;
  late _MockLogoutUseCase logout;
  late _MockGetCurrentUserUseCase currentUser;
  late AuthStateNotifier notifier;

  setUp(() {
    login = _MockLoginUseCase();
    register = _MockRegisterUseCase();
    logout = _MockLogoutUseCase();
    currentUser = _MockGetCurrentUserUseCase();
    notifier = AuthStateNotifier(login, register, logout, currentUser);
  });

  test('login success updates user and clears loading', () async {
    final user = User(id: 'u1', email: 'john@doe.com', name: 'John Doe');
    when(() => login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => AuthToken(
              accessToken: 'access',
              refreshToken: 'refresh',
              expiresAt: DateTime.now().add(const Duration(hours: 1)),
            ));
    when(currentUser.call).thenAnswer((_) async => user);

    await notifier.login('john@doe.com', 'secret1');

    expect(notifier.state.isLoading, false);
    expect(notifier.state.user, isNotNull);
    expect(notifier.state.user?.email, 'john@doe.com');
    expect(notifier.state.errorMessage, isNull);
  });

  test('register failure sets error', () async {
    when(() => register(email: any(named: 'email'), password: any(named: 'password'), name: any(named: 'name'), phone: any(named: 'phone')))
        .thenThrow(ArgumentError('Invalid email format'));

    await notifier.register(email: 'bad', password: '123', name: 'A');

    expect(notifier.state.isLoading, false);
    expect(notifier.state.user, isNull);
    expect(notifier.state.errorMessage, contains('Invalid email format'));
  });

  test('logout resets state', () async {
    when(logout.call).thenAnswer((_) async {});

    await notifier.logout();

    expect(notifier.state.user, isNull);
    expect(notifier.state.isLoading, false);
    expect(notifier.state.errorMessage, isNull);
  });
}
import 'package:cloudbarber/features/auth/domain/entities/auth_token.dart';
