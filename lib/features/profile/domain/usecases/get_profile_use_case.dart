import 'package:cloudbarber/features/auth/domain/entities/user.dart';
import 'package:cloudbarber/features/profile/domain/repositories/profile_repository.dart';

/// Use case for getting user profile
class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<User> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    return await repository.getProfile(userId);
  }
}
