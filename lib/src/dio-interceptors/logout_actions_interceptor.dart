import 'package:dio/dio.dart';

class LogoutActionsInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null && err.response!.statusCode == 401) {
      // AppActionNavigator.doAction(AppAction.logOutUser);
    }
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      // AppActionNavigator.doAction(AppAction.logOutUser);
    }
    return handler.next(response);
  }
}
