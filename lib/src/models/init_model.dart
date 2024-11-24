import 'package:flutter/foundation.dart';
import 'package:mc_dio_wrapper/src/enums/log_details.dart';

abstract final class InitModel {
  static String apiBaseUrl = 'https://example.com';
  static Map<String, String> extraHeaders = const {};
  static LogDetails httpLoggerLevel = LogDetails.detailed;
  static Duration maxCacheAge = const Duration(days: 2);
  static String apiVersion = 'v1';
  static ValueGetter<String?> token = () => null;
  static bool enableCaching = false;
  static bool isLocalizedApi = false;
}
