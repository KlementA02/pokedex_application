import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../infrastructure/innox_authenticator.dart';


class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = IAuthenticator.token;
    debugPrint('🔑 Token on request: ${token != null ? "present" : "missing"}');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      debugPrint('❌ 401 Unauthorized — token may be expired or missing');
    }
    handler.next(err);
  }
}