import 'package:cloudbarber/features/auth/domain/entities/user.dart';
import 'package:cloudbarber/features/auth/domain/entities/auth_token.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<AuthToken> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<AuthToken> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  /// Logout the current user
  Future<void> logout();

  /// Get the current authenticated user
  Future<User?> getCurrentUser();

  /// Refresh the authentication token
  Future<AuthToken> refreshToken(String refreshToken);

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Request password reset
  Future<void> requestPasswordReset(String email);

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
}
