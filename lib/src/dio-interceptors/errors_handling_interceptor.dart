import 'package:dio/dio.dart';
import 'package:mc_dio_wrapper/src/helpers/extensions/int_extension.dart';
import 'package:mc_dio_wrapper/src/helpers/logger.dart';
import 'package:mc_dio_wrapper/src/models/mc_dio_error.dart';

class ErrorsHandlingInterceptor implements Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode != null && response.statusCode!.isBetween(399, 599)) {
      final DioException dioError = DioException(
        type: DioExceptionType.badResponse,
        response: response,
        error: response.data['errors'] ?? response.data['error'] ?? response.statusMessage,
        requestOptions: response.requestOptions,
        message: response.data['message'] ?? response.statusMessage,
      );
      // boolean param is "Call Following Error Interceptor"; Must always true
      return handler.reject(dioError, true);
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    const String errKey = "SocketException: Failed host lookup:";
    if (err.error.toString().contains(errKey)) {
      final DioException errorObject = DioException.connectionError(
        requestOptions: err.requestOptions,
        reason: McDioError.noInternetConnectionKey,
      );
      handler.reject(errorObject);
      return;
    }
    String? errMsg = err.response?.data!['message'];
    if (errMsg != null && errMsg.isEmpty) {
      errMsg = null;
    }
    final DioException errorObject = DioException(
      type: DioExceptionType.badResponse,
      response: err.response,
      error: err.error,
      requestOptions: err.requestOptions,
      message: errMsg ?? err.message,
    );
    AppLogger().handler(errorObject, errorObject.stackTrace);
    handler.reject(errorObject);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }
}
