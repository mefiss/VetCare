import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/environment.dart';
import 'api_exception.dart';

/// Configured Dio instance for PetCare API.
class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: Environment.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.data is Map<String, dynamic>) {
          final apiError = ApiException.fromJson(
            error.response!.data as Map<String, dynamic>,
            error.response?.statusCode,
          );
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: apiError,
            response: error.response,
          ));
        } else {
          handler.next(error);
        }
      },
    ));

    // Logging only in debug mode
    assert(() {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
      return true;
    }());
  }
}

/// Singleton Riverpod provider for the API client.
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
