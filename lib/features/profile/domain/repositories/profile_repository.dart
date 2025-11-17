import 'package:cloudbarber/features/auth/domain/entities/user.dart';

/// Repository interface for profile operations
abstract class ProfileRepository {
  /// Get user profile
  Future<User> getProfile(String userId);

  /// Update user profile
  Future<User> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? profileImageUrl,
  });

  /// Update user email
  Future<void> updateEmail({
    required String userId,
    required String newEmail,
    required String password,
  });

  /// Update user password
  Future<void> updatePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  /// Delete user account
  Future<void> deleteAccount(String userId);
}
