import 'package:json_annotation/json_annotation.dart';

part 'token_response_model.g.dart';

@JsonSerializable()
class TokenResponseModel {
  final String token;

  TokenResponseModel({
    required this.token,
  });

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseModelToJson(this);

  dynamic operator [](String key) {
    switch (key) {
      case 'token':
        return token;
      default:
        return null;
    }
  }
}
