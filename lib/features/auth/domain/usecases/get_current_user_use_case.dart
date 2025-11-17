import 'package:cloudbarber/features/auth/domain/entities/user.dart';
import 'package:cloudbarber/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting the current user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getCurrentUser();
  }
}
