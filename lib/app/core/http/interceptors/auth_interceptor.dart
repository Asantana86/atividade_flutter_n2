import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/app.config.dart';
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    final anonKey = AppConfig.supabaseKey;
    if (anonKey.isNotEmpty) {
      options.headers['apikey'] = anonKey;
    }

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    } else if (anonKey.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $anonKey';
    }

    options.headers['User-Agent'] = 'ServiceFlow/1.0';

    debugPrint('🌐 ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        '❌ ${err.response?.statusCode} ${err.requestOptions.path}: ${err.message}');
    super.onError(err, handler);
  }
}