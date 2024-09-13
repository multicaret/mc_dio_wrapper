import 'package:dio/dio.dart';

extension ExtensionDioResponse on Response {
  bool get isValidToStore {
    return statusCode != null && statusCode! >= 200 && statusCode! < 300;
  }

  bool get isSuccess {
    return statusCode == 200;
  }
}
