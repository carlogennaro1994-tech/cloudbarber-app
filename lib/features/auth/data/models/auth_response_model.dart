import 'package:json_annotation/json_annotation.dart';
import 'package:cloudbarber/features/auth/data/models/user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final String token;
  final UserModel user;

  AuthResponseModel({
    required this.token,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  dynamic operator [](String key) {
    switch (key) {
      case 'token':
        return token;
      case 'user':
        // Return as Map to allow nested map-style access
        return user.toJson();
      default:
        return null;
    }
  }
}
