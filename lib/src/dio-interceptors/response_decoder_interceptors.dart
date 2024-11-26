import 'dart:developer' show log;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mc_dio_wrapper/src/helpers/extensions/string_extension.dart';
import 'package:mc_dio_wrapper/src/helpers/logger.dart';
import 'package:mc_dio_wrapper/src/helpers/package_keys.dart';
import 'package:mc_dio_wrapper/src/models/init_model.dart';
import 'package:mc_dio_wrapper/src/models/mc_dio_error.dart';

class DecoderInterceptors<T> extends QueuedInterceptor {
  final ComputeCallback<Map<String, dynamic>, T> conv;
  final bool hasToken;

  DecoderInterceptors(this.conv, this.hasToken);

  String get token => InitModel.token() ?? '';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (hasToken && token.isNotEmpty) {
      final String tokenValue = 'Bearer $token';
      options.headers['Authorization'] = tokenValue;
      if (!InitModel.httpLoggerLevel.isNone) {
        _printToken(tokenValue);
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      response.data = await compute<Map<String, dynamic>, T>(conv, response.data);
    } catch (e) {
      final DioException errorObject = _getDioError(response, e);
      AppLogger().error(McDioError(errorObject).toString(), errorObject);
    }
    return super.onResponse(response, handler);
  }

  DioException _getDioError(Response<dynamic> response, Object e) {
    return DioException(
      requestOptions: response.requestOptions,
      message: "${e.toString()} on using ${conv.runtimeType}",
      stackTrace: e is TypeError ? e.stackTrace : null,
      error: e,
      response: response,
      type: DioExceptionType.unknown,
    );
  }

  void _printToken(String tokenValue) {
    String substring = tokenValue.afterFirst('|').substring(0, 25);
    String hiddenToken = tokenValue.replaceFirst(substring, '*' * substring.length);
    String message = '𝍌 Headers: Authorization->$hiddenToken';
    if (InitModel.httpLoggerLevel.isCompact) {
      log(message, name: PackageKeys.name);
    }
    if (InitModel.httpLoggerLevel.isDetailed) {
      AppLogger().info(message);
    }
  }
}
