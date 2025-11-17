import 'package:cloudbarber/features/auth/domain/entities/auth_token.dart';
import 'package:cloudbarber/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthToken> call({
    required String email,
    required String password,
    required String name,
    String? phone,
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

    // Validate name
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    if (name.length < 2) {
      throw ArgumentError('Name must be at least 2 characters');
    }

    // Validate phone if provided
    if (phone != null && phone.isNotEmpty && !_isValidPhone(phone)) {
      throw ArgumentError('Invalid phone number format');
    }

    return await repository.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
}
