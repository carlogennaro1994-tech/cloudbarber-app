import 'package:cloudbarber/features/auth/domain/entities/user.dart';
import 'package:cloudbarber/features/profile/domain/repositories/profile_repository.dart';

/// Use case for updating user profile
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<User> call({
    required String userId,
    String? name,
    String? phone,
    String? profileImageUrl,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    // Validate name if provided
    if (name != null && name.isNotEmpty && name.length < 2) {
      throw ArgumentError('Name must be at least 2 characters');
    }

    // Validate phone if provided
    if (phone != null && phone.isNotEmpty && !_isValidPhone(phone)) {
      throw ArgumentError('Invalid phone number format');
    }

    return await repository.updateProfile(
      userId: userId,
      name: name,
      phone: phone,
      profileImageUrl: profileImageUrl,
    );
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
}
