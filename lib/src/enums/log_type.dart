import 'package:recase/recase.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum LogType {
  error(1200),
  warning(1000),
  alert(900),
  notice(800),
  info(700),
  debug(500),
  ;

  final int level;

  const LogType(this.level);
}

extension LogTypeListHelper<T extends LogType> on Iterable<T> {
  Map<String, LogType> asTitles() {
    return <String, LogType>{for (var value in this) value.title: value};
  }
}

extension LogTypeExtension on LogType {
  String get title {
    return name.titleCase;
  }

  LogLevel get talkerLevel {
    switch (this) {
      case LogType.error:
        return LogLevel.error;
      case LogType.warning:
        return LogLevel.warning;
      case LogType.alert:
        return LogLevel.verbose;
      case LogType.notice:
        return LogLevel.debug;
      case LogType.info:
        return LogLevel.info;
      case LogType.debug:
        return LogLevel.debug;
      default:
        throw Exception('Invalid log level');
    }
  }
}
