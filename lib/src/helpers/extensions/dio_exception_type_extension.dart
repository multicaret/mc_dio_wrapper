import 'package:dio/dio.dart';

extension ExtensionDioExceptionTypeHelper on DioExceptionType {
  String title() {
    return name.toUpperCase();
  }
}
