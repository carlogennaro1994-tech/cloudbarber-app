import 'package:cloudbarber/features/auth/domain/entities/auth_token.dart';
import 'package:cloudbarber/features/auth/domain/entities/user.dart';
import 'package:cloudbarber/features/auth/domain/repositories/auth_repository.dart';
import 'package:cloudbarber/features/auth/data/datasources/auth_api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient apiClient;
  final FlutterSecureStorage secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  AuthRepositoryImpl(this.apiClient, this.secureStorage);

  @override
  Future<AuthToken> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.login({
        'email': email,
        'password': password,
      });

      final token = AuthToken(
        accessToken: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresAt: DateTime.parse(response['expires_at']),
      );

      // Save tokens securely
      await secureStorage.write(key: _tokenKey, value: token.accessToken);
      await secureStorage.write(key: _refreshTokenKey, value: token.refreshToken);

      return token;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AuthToken> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      final response = await apiClient.register({
        'email': email,
        'password': password,
        'name': name,
        if (phone != null) 'phone': phone,
      });

      final token = AuthToken(
        accessToken: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresAt: DateTime.parse(response['expires_at']),
      );

      // Save tokens securely
      await secureStorage.write(key: _tokenKey, value: token.accessToken);
      await secureStorage.write(key: _refreshTokenKey, value: token.refreshToken);

      return token;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.logout();
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      // Always clear local tokens
      await secureStorage.delete(key: _tokenKey);
      await secureStorage.delete(key: _refreshTokenKey);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final token = await secureStorage.read(key: _tokenKey);
      if (token == null) {
        return null;
      }

      final userModel = await apiClient.getCurrentUser();
      return userModel.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthToken> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.refreshToken({
        'refresh_token': refreshToken,
      });

      final token = AuthToken(
        accessToken: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresAt: DateTime.parse(response['expires_at']),
      );

      // Update stored tokens
      await secureStorage.write(key: _tokenKey, value: token.accessToken);
      await secureStorage.write(key: _refreshTokenKey, value: token.refreshToken);

      return token;
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: _tokenKey);
    return token != null;
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      await apiClient.requestPasswordReset({'email': email});
    } catch (e) {
      throw Exception('Password reset request failed: $e');
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await apiClient.resetPassword({
        'token': token,
        'new_password': newPassword,
      });
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
}
