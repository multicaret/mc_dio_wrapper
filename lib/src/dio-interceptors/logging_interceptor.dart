import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mc_dio_wrapper/src/helpers/extensions/string_extension.dart';
import 'package:mc_dio_wrapper/src/helpers/logger.dart';

class LoggingInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final AppLogger log = AppLogger();
    String errMsg = '❌ Dio Error - Status code: ${err.response?.statusCode ?? 'Unknown'}';
    String method = err.response?.requestOptions.method.toUpperCase() ?? '';
    log.error(errMsg, err, err.stackTrace);
    log.error('<----$method:${err.response?.requestOptions.uri.toString()}', err, err.stackTrace);
    log.error(err.message ?? 'Empty Error Message', err, err.stackTrace);
    log.divider();
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final AppLogger log = AppLogger();
    log.divider();
    log.info('➡️ ➡️ ➡️ Request');
    log.info('----> ${options.method.toUpperCase()}:${options.uri.toString()}');
    if (options.queryParameters.isNotEmpty) {
      String params = '';
      options.queryParameters.forEach((key, value) {
        params += '🧪 $key:$value\n';
      });
      log.info('Query Parameters: \n$params');
    }
    if (options.data != null && options.data is FormData) {
      final FormData payload = options.data;
      payload.fields.toList().forEach((MapEntry<String, String> element) {
        final String payloadLogString =
            '📬 Post body ...key->value: ${element.key}->${element.value}';
        final String clearedLog = kDebugMode ? payloadLogString : payloadLogString.clearLogPassword;
        log.info(clearedLog);
      });
      payload.files.toList().forEach((MapEntry<String, MultipartFile> element) {
        log.info('📂  Post files ...key->value: ${element.key}=>${element.value.filename}');
      });
    }
    log.divider();
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final AppLogger log = AppLogger();
    log.info('⬅️ ⬅️ ⬅️ Response');
    final String statusCode = response.statusCode != 200 ? '❌ ${response.statusCode} ❌' : '✅ 200 ✅';
    log.info('<---- $statusCode ${response.requestOptions.uri.toString()}');
    log.divider();
    return handler.next(response);
  }
}
