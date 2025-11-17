import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Register FlutterSecureStorage
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
  
  // Register Dio for HTTP client
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.cloudbarber.com', // Replace with your API base URL
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  
  // Add interceptors for logging and auth
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  );
  
  getIt.registerSingleton<Dio>(dio);
  
  // Initialize other dependencies
  // This would be auto-generated with @injectable annotations
  // getIt.init();
}

// Example of how to use injectable annotations:
// 
// @injectable
// class AuthRepository {
//   final Dio dio;
//   final FlutterSecureStorage secureStorage;
//   
//   AuthRepository(this.dio, this.secureStorage);
// }
// 
// @injectable
// class AuthService {
//   final AuthRepository repository;
//   
//   AuthService(this.repository);
// }
