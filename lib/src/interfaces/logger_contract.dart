import 'package:mc_dio_wrapper/src/enums/log_type.dart';

abstract interface class AppLoggerContract {
  void log(String message, LogType type, {Object? error, StackTrace? stackTrace});

  void handle(dynamic error, [StackTrace? stackTrace, String? msg]);
}
