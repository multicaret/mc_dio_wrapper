import 'dart:async';
import 'dart:developer' as main_logger show log;

import 'package:dio/dio.dart';
import 'package:mc_dio_wrapper/src/helpers/package_keys.dart';

class MiniLoggerInterceptor extends QueuedInterceptor {
  MiniLoggerInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger('➡️ ➡️ ➡️ Request', name: PackageKeys.name);
    _logger('${options.method.toUpperCase()}:${options.uri.toString()}', name: PackageKeys.name);
    options.headers.forEach((String key, dynamic value) {
      _logger('𝍌 Headers: $key->${value.toString()}', name: PackageKeys.name);
    });
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger('⬅️ ⬅️ ⬅️ Response', name: PackageKeys.name);
    final String statusCode = response.statusCode != 200 ? '❌ ${response.statusCode} ❌' : '✅ 200 ✅';
    _logger('$statusCode ${response.requestOptions.uri.toString()}', name: PackageKeys.name);
    _logger('-------------------------', name: PackageKeys.name);
    return handler.next(response);
  }

  void _logger(String message,
      {Object? error,
      int level = 0,
      String name = '',
      int? sequenceNumber,
      StackTrace? stackTrace,
      DateTime? time,
      Zone? zone}) {
    main_logger.log(message,
        name: name,
        error: error,
        level: level,
        sequenceNumber: sequenceNumber,
        stackTrace: stackTrace,
        time: time,
        zone: zone);
  }
}
