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
    final StringBuffer onRequestBuffer = StringBuffer('\n');
    onRequestBuffer.writeln('➡️ ➡️ ➡️ Request');
    onRequestBuffer.writeln('----> ${options.method.toUpperCase()}:${options.uri.toString()}');

    onRequestBuffer.writeln('𝍌 Headers:');
    options.headers.forEach((String key, dynamic value) {
      onRequestBuffer.writeln(' - $key->${value.toString()}');
    });

    if (options.queryParameters.isNotEmpty) {
      onRequestBuffer.writeln('Query Parameters:');
      options.queryParameters.forEach((String key, dynamic value) {
        onRequestBuffer.writeln('🧪 $key:$value');
      });
    }
    if (options.data != null && options.data is FormData) {
      final FormData payload = options.data;

      payload.fields.toList().forEach((MapEntry<String, String> element) {
        final String payloadLine = '📬 Post body ...key->value: ${element.key}->${element.value}';
        final String clearedLog = kDebugMode ? payloadLine : payloadLine.clearLogPassword;
        onRequestBuffer.writeln(clearedLog);
      });

      payload.files.toList().forEach((MapEntry<String, MultipartFile> element) {
        String fileText = '📂  Post files ...key->value: ${element.key}=>${element.value.filename}';
        onRequestBuffer.writeln(fileText);
      });
    }
    onRequestBuffer.writeln('-------------------------');

    final AppLogger log = AppLogger();
    log.info(onRequestBuffer.toString());

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final StringBuffer onResponseBuffer = StringBuffer('\n');
    onResponseBuffer.writeln('⬅️ ⬅️ ⬅️ Response');

    final String statusCode = response.statusCode != 200 ? '❌ ${response.statusCode} ❌' : '✅ 200 ✅';
    onResponseBuffer.writeln('<---- $statusCode ${response.requestOptions.uri.toString()}');
    onResponseBuffer.writeln('-------------------------');

    final AppLogger log = AppLogger();
    log.info(onResponseBuffer.toString());

    return handler.next(response);
  }
}
