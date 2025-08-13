import 'package:dio/dio.dart';
import 'package:mc_dio_wrapper/src/models/init_model.dart' show InitModel;

class LogoutActionsInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null && err.response!.statusCode == 401) {
      InitModel.logoutDoer?.call(InitModel.logoutDoerParam);
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
      InitModel.logoutDoer?.call(InitModel.logoutDoerParam);
    }
    return handler.next(response);
  }
}
