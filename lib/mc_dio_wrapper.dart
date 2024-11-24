library mc_dio_wrapper;

import 'package:flutter/foundation.dart';
import 'package:mc_dio_wrapper/src/interfaces/base_response.dart';
import 'package:mc_dio_wrapper/src/models/init_model.dart';

import 'mc_dio_wrapper.dart';
import 'src/service/dio_http_service.dart';

export 'src/enums/log_details.dart';
export 'src/interfaces/http_service_contract.dart';
export 'src/models/api_endpoints.dart' show ApiEndpoints;
export 'src/models/http_request_payload.dart';
export 'src/models/http_request_query_params.dart';
export 'src/models/mc_dio_error.dart';
export 'src/models/mc_response.dart';
export 'src/types/package_types.dart';

base class McWrapperBaseResponse<T> extends BaseResponse<T> {
  McWrapperBaseResponse({
    required super.data,
    required super.errors,
    required super.message,
    required super.status,
  });
}

base class McHttpWrapper<T> extends DioHttpService<T> {}

abstract class McHttpWrapperInitializer {
  static Future<void> by({
    required String baseUrl,
    String apiVersion = '',
    LogDetails httpLoggerLevel = LogDetails.compact,
    Map<String, String> headers = const {},
    bool enableCaching = false,
    bool isLocalizedApi = false,
    ValueGetter<String?>? tokenLoader,
  }) async {
    InitModel.apiBaseUrl = baseUrl;
    InitModel.extraHeaders = headers;
    InitModel.apiVersion = apiVersion;
    InitModel.httpLoggerLevel = httpLoggerLevel;
    InitModel.enableCaching = enableCaching;
    InitModel.isLocalizedApi = isLocalizedApi;
    if (tokenLoader != null) {
      InitModel.token = tokenLoader;
    }
  }
}
