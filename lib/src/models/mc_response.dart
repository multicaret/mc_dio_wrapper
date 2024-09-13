import 'package:dio/dio.dart';

class McResponse<T> extends Response<T> {
  McResponse({
    required super.requestOptions,
    super.data,
    super.statusCode,
    super.statusMessage,
    super.isRedirect = false,
    super.redirects = const [],
    super.extra,
    super.headers,
  });
}
