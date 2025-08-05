import 'package:dio/dio.dart';
import '../store/store.dart';

class RequestNetwork extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Always add Accept header
    options.headers['Accept'] = 'application/json';
    
    // Add Authorization header if token exists
    final token = StoreData.instant.token;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      print('🔐 RequestNetwork: Added auth token to request');
    }
    
    super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      print('🔐 RequestNetwork: 401 Unauthorized - token may be invalid');
      // You could trigger logout here if needed
    }
    
    super.onError(err, handler);
  }
}