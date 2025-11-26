import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:cloudbarber/features/auth/data/models/user_model.dart';
import 'package:cloudbarber/features/auth/data/models/auth_response_model.dart';
import 'package:cloudbarber/features/auth/data/models/token_response_model.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST('/auth/login')
  Future<AuthResponseModel> login(@Body() Map<String, dynamic> body);

  @POST('/auth/register')
  Future<AuthResponseModel> register(@Body() Map<String, dynamic> body);

  @POST('/auth/logout')
  Future<void> logout();

  @GET('/auth/me')
  Future<UserModel> getCurrentUser();

  @POST('/auth/refresh')
  Future<TokenResponseModel> refreshToken(@Body() Map<String, dynamic> body);

  @POST('/auth/password/reset/request')
  Future<void> requestPasswordReset(@Body() Map<String, dynamic> body);

  @POST('/auth/password/reset')
  Future<void> resetPassword(@Body() Map<String, dynamic> body);
}