import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../interceptors/error_interceptors.dart';
import '../interceptors/rate_limit_interceptors.dart';
import '../exception_handler/nominatim_exception.dart';

class ApiService {
  static const String baseUrl = 'https://nominatim.openstreetmap.org';
  late final Dio _dio;

  ApiService._();
  static final ApiService instance = ApiService._();

  initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {'User-Agent': 'Flutter_Nominatim_Plugin/1.0'},
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ))
      ..interceptors.addAll([
        // DioCacheInterceptor(options: cacheOptions),
        ErrorInterceptor(),
        RateLimitInterceptor(),
      ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      debugPrint('GET error: $e');
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return NominatimException('Connection timeout');
        case DioExceptionType.receiveTimeout:
          return NominatimException('Receive timeout');
        case DioExceptionType.badResponse:
          return _handleHttpError(error.response?.statusCode);
        default:
          return NominatimException('Network error: ${error.message}');
      }
    }
    return NominatimException('Unexpected error occurred');
  }

  Exception _handleHttpError(int? statusCode) {
    switch (statusCode) {
      case 429:
        return NominatimException('Rate limit exceeded', code: '429');
      case 500:
        return NominatimException('Server error', code: '500');
      default:
        return NominatimException('HTTP error: $statusCode');
    }
  }
}
