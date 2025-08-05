import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../store/store.dart';
import 'request_network.dart';

class DioNetwork {
  DioNetwork._();
  static DioNetwork instant = DioNetwork._();
  late BaseOptions _options;
  late String url;
  late Dio dio;

  bool loggingInterceptorEnabled = true;

  Future init(String url, {BaseOptions? options, bool isAuth = false}) async {
    _options = options ??
        BaseOptions(
          baseUrl: url,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 300),
          receiveTimeout: const Duration(seconds: 300),
          responseType: ResponseType.json,
        );
    
    // Note: Authorization header is now handled by RequestNetwork interceptor
    // This ensures consistent token handling across all requests
    if (isAuth == true) {
      final token = StoreData.instant.token;
      print('🔑 DioNetwork: isAuth=true, token=${token.isEmpty ? "EMPTY" : "EXISTS(${token.length} chars)"}');
    } else {
      print('🔑 DioNetwork: isAuth=false');
    }
    
    _options.headers.remove(Headers.contentLengthHeader);
    dio = Dio(_options);
    // ignore: deprecated_member_use
    if (!kIsWeb) {
      // ignore: deprecated_member_use
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    dio.interceptors.addAll([
      RequestNetwork(),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }
}