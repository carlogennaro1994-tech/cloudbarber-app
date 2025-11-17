import 'package:cloudbarber/features/auth/domain/entities/auth_token.dart';
import 'package:cloudbarber/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthToken> call({
    required String email,
    required String password,
  }) async {
    // Validate email
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    // Validate password
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    return await repository.login(
      email: email,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
