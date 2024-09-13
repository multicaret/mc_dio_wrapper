import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mc_dio_wrapper/src/helpers/package_keys.dart';

class MiniLoggerInterceptor extends QueuedInterceptor {
  MiniLoggerInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('➡️ ➡️ ➡️ Request', name: PackageKeys.name);
    log('${options.method.toUpperCase()}:${options.uri.toString()}', name: PackageKeys.name);
    options.headers.forEach((String key, dynamic value) {
      log('𝍌 Headers: $key->${value.toString()}', name: PackageKeys.name);
    });
    return super.onRequest(options, handler);
  }
}
