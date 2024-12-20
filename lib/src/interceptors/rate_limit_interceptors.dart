import 'package:dio/dio.dart';

class RateLimitInterceptor extends Interceptor {
  static DateTime? _lastRequestTime;
  static const _minRequestInterval = Duration(seconds: 1);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        await Future.delayed(_minRequestInterval - timeSinceLastRequest);
      }
    }
    _lastRequestTime = DateTime.now();
    handler.next(options);
  }
}
