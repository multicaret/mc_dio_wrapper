import 'dart:convert';
import 'dart:developer' as main_logger;
import 'dart:io';

import 'package:mc_dio_wrapper/src/enums/log_type.dart';
import 'package:mc_dio_wrapper/src/interfaces/logger_contract.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package_keys.dart';

class AppLogger {
  final String _name = PackageKeys.name;
  static late AppLoggerContract _loggerHandler;

  AppLogger() {
    final Talker talker = TalkerFlutter.init(
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          defaultTitle: _name,
        ),
      ),
    );

    _loggerHandler = _AppTalkerLogger(talker);
  }

  static printMap({
    required Map map,
    StackTrace? stackTrace,
    LogType? type,
  }) {
    final TalkerLogger logger = TalkerLogger(
      settings: TalkerLoggerSettings(
        level: type?.talkerLevel ?? LogLevel.verbose,
      ),
    );

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyData = encoder.convert(map);
    logger.log(prettyData);
  }

  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _loggerHandler.log(message, LogType.info, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _loggerHandler.log(message, LogType.warning, error: error, stackTrace: stackTrace);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _loggerHandler.log(message, LogType.error, error: error, stackTrace: stackTrace);
  }

  void divider() {
    _loggerHandler.log('-------------------------', LogType.info);
  }

  static Future<File> getFileOfLogRecord() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/appLogOutput.txt');
  }

  void handler(dynamic errorObject, [StackTrace? stack, String? msg]) {
    dynamic error = errorObject.error ?? errorObject.message ?? 'Error "NULL"';
    _loggerHandler.handle(error, errorObject.stackTrace, msg);
  }
}

class _AppTalkerLogger implements AppLoggerContract {
  final Talker _talker;

  _AppTalkerLogger(this._talker);

  @override
  void log(String message, LogType type, {Object? error, StackTrace? stackTrace}) {
    if (PackageKeys.enableTalkerLogger) {
      switch (type) {
        case LogType.error:
          _talker.error(message, [error, stackTrace]);
          break;
        case LogType.info:
          _talker.info(message, [error, stackTrace]);
          break;
        case LogType.warning:
          _talker.warning(message, [error, stackTrace]);
          break;
        case LogType.alert:
          _talker.info(message, [error, stackTrace]);
          break;
        case LogType.debug:
          _talker.debug(message, [error, stackTrace]);
          break;
        case LogType.notice:
          _talker.verbose(message, [error, stackTrace]);
          break;
      }
    } else {
      main_logger.log(message,
          error: error, stackTrace: stackTrace, level: type.level, name: type.title);
    }
  }

  @override
  void handle(error, [StackTrace? stackTrace, String? msg]) {
    _talker.handle(error, stackTrace, msg);
  }
}
