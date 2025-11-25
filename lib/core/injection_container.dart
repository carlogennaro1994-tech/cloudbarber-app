import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:cloudbarber/features/auth/data/datasources/auth_api_client.dart';
import 'package:cloudbarber/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cloudbarber/features/auth/domain/repositories/auth_repository.dart';
import 'package:cloudbarber/features/booking/data/datasources/booking_api_client.dart';
import 'package:cloudbarber/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:cloudbarber/features/booking/domain/repositories/booking_repository.dart';

final getIt = GetIt.instance;

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
  
  // Add auth interceptor to add token to requests
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );
  
  getIt.registerSingleton<Dio>(dio);
  
  // Register API clients
  getIt.registerLazySingleton<AuthApiClient>(
    () => AuthApiClient(getIt<Dio>()),
  );
  getIt.registerLazySingleton<BookingApiClient>(
    () => BookingApiClient(getIt<Dio>()),
  );
  
  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthApiClient>(),
      getIt<FlutterSecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      getIt<BookingApiClient>(),
    ),
  );
}
