import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';
part 'auth_token.g.dart';

/// Represents authentication tokens
@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _AuthToken;

  const AuthToken._();

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);

  /// Checks if the token is expired
  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Checks if the token is about to expire (within 5 minutes)
  bool get isAboutToExpire {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiresAt);
  }
}
