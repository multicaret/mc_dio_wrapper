import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart' hide BaseResponse;
import 'package:flutter/foundation.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:mc_dio_wrapper/mc_dio_wrapper.dart';
import 'package:mc_dio_wrapper/src/dio-interceptors/errors_handling_interceptor.dart';
import 'package:mc_dio_wrapper/src/dio-interceptors/logging_interceptor.dart';
import 'package:mc_dio_wrapper/src/dio-interceptors/mini_logger_interceptors.dart';
import 'package:mc_dio_wrapper/src/dio-interceptors/response_decoder_interceptors.dart';
import 'package:mc_dio_wrapper/src/helpers/extensions/string_extension.dart';
import 'package:mc_dio_wrapper/src/helpers/package_keys.dart';
import 'package:mc_dio_wrapper/src/interfaces/base_response.dart';
import 'package:mc_dio_wrapper/src/models/init_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class DioHttpService<T> implements HttpServiceContract {
  final String _apiBaseUrl = InitModel.apiBaseUrl;
  final Map<String, String> _extraHeaders = InitModel.extraHeaders;
  final String _localeCode;

  DioHttpService([this._localeCode = 'en']);

  String get _apiOrigin => _apiBaseUrl;

  Map<String, String> get _headers {
    return Map.fromEntries(
      [
        const MapEntry(Headers.acceptHeader, Headers.jsonContentType),
        ..._extraHeaders.entries,
      ],
    );
  }

  String get _apiVersion => InitModel.apiVersion.isNotEmpty ? 'api/${InitModel.apiVersion}' : '';

  String get _localeSegment => InitModel.isLocalizedApi ? '/$_localeCode' : '';

  BaseOptions get _baseOptions {
    return BaseOptions(
      baseUrl: '$_apiOrigin$_localeSegment/$_apiVersion',
      validateStatus: (int? status) => PackageKeys.validateStatus,
      contentType: Headers.jsonContentType,
      listFormat: ListFormat.multiCompatible,
      headers: _headers,
    );
  }

  @override
  Future<McResponse<E>> get<E extends BaseResponse>(
    String endpoint, {
    required E Function(Map<String, dynamic> json) converter,
    RequestQueryParams? queryParameters,
    bool hasToken = false,
  }) async {
    endpoint = _urlValidator(endpoint);

    final Dio dio = await _getDioWithDefaultSettings(isNotApiOrigin: endpoint.isUrl);

    final DecoderInterceptors<E> decoderInterceptor = DecoderInterceptors<E>(converter, hasToken);
    dio.interceptors.add(decoderInterceptor);

    Response<E> response = await dio.get<E>(
      endpoint,
      queryParameters: queryParameters,
      // onReceiveProgress: _oSp,
    );
    return McResponse<E>(
      requestOptions: response.requestOptions,
      data: response.data,
      statusCode: response.statusCode,
      headers: response.headers,
      extra: response.extra,
      isRedirect: response.isRedirect,
      redirects: response.redirects,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<McResponse<E>> post<E extends BaseResponse>(
    String endpoint, {
    required E Function(Map<String, dynamic> json) converter,
    RequestQueryParams? queryParameters,
    HttpRequestPayload? payload,
    List<File>? galleryFiles,
    bool hasToken = false,
  }) async {
    endpoint = _urlValidator(endpoint);

    // Work on body values types [strings, list ...etc]
    Map<String, dynamic> dioFormData = {};
    _preparePostPayload(payload, dioFormData);

    // Load post images files
    FormData formData = FormData.fromMap(dioFormData);
    await _loadPostFiles(galleryFiles, formData);

    // Prepare request options
    final Options requestOptions = Options(
      contentType: Headers.formUrlEncodedContentType,
    );

    final Dio dio = await _getDioWithDefaultSettings(isNotApiOrigin: endpoint.isUrl);

    final DecoderInterceptors<E> decoderInterceptor = DecoderInterceptors<E>(converter, hasToken);
    dio.interceptors.add(decoderInterceptor);

    final Response<E> response = await dio.post<E>(
      endpoint,
      queryParameters: queryParameters,
      data: formData,
      options: requestOptions,
      // onSendProgress: _oSp,
      // onReceiveProgress: _oRp,
    );

    return McResponse<E>(
      requestOptions: response.requestOptions,
      data: response.data,
      statusCode: response.statusCode,
      headers: response.headers,
      extra: response.extra,
      isRedirect: response.isRedirect,
      redirects: response.redirects,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<McResponse<E>> delete<E extends BaseResponse>(
    String endpoint, {
    required E Function(Map<String, dynamic> json) converter,
    RequestQueryParams? queryParameters,
    bool hasToken = false,
  }) async {
    endpoint = _urlValidator(endpoint);
    final Dio dio = await _getDioWithDefaultSettings(isNotApiOrigin: endpoint.isUrl);

    final DecoderInterceptors<E> decoderInterceptor = DecoderInterceptors<E>(converter, hasToken);
    dio.interceptors.add(decoderInterceptor);

    final Response<E> response = await dio.delete<E>(
      endpoint,
      queryParameters: queryParameters,
    );
    return McResponse<E>(
      requestOptions: response.requestOptions,
      data: response.data,
      statusCode: response.statusCode,
      headers: response.headers,
      extra: response.extra,
      isRedirect: response.isRedirect,
      redirects: response.redirects,
      statusMessage: response.statusMessage,
    );
  }

  String _urlValidator(String endpoint) {
    if (!endpoint.isUrl) {
      endpoint = endpoint.startsWith('/') ? endpoint : "/$endpoint";
    }
    return endpoint;
  }

  // On Send Progress
  // _oSp(int sent, int total) {
  //   if (sendProgress != null && total > 0 && sendProgress.mounted) {
  //     final double percent =
  //         double.parse((((sent / total) * 100)).toStringAsFixed(2));
  //     if (!kDebugMode) {
  //       sendProgress.update((state) => percent);
  //     }
  //   } else {
  //     if (total > 0) {
  //       // AppLogger().warning('🧠😜 sendProgress->mounted =====>  ${sendProgress.mounted}');
  //     }
  //   }
  // }

  // On Receive Progress
  // _oRp(int sent, int total) {
  // AppLogger().warning('🧠😜 ORP sent($sent) =====>  total($total)');
  // }

  Future<void> _loadPostFiles(List<File>? galleryFiles, FormData formData) async {
    if (galleryFiles != null && galleryFiles.isNotEmpty) {
      await Future.forEach(galleryFiles, (File file) async {
        final String filePath = file.path;
        final String filename = path.basename(filePath);
        formData.files.addAll([
          MapEntry("gallery[]", await MultipartFile.fromFile(filePath, filename: filename)),
        ]);
      });
    }
  }

  void _preparePostPayload(Map<String, dynamic>? payload, Map<String, dynamic> dioFormData) {
    if (payload != null && payload.isNotEmpty) {
      payload.forEach((String formKey, dynamic itemValue) {
        if (itemValue != null) {
          if (itemValue is File) {
            final String filePath = itemValue.path;
            final String filename = path.basename(filePath);
            if (filePath.isNotEmpty) {
              dioFormData[formKey] = MultipartFile.fromFileSync(filePath, filename: filename);
            } else {
              debugPrint('Error filePath: $filePath');
            }
          } else {
            if (itemValue is List) {
              formKey = formKey.endsWith('[]') ? formKey : "$formKey[]";
            }
            dioFormData[formKey] = itemValue;
          }
        }
      });
    }
  }

  Future<Dio> _getDioWithDefaultSettings({bool isNotApiOrigin = false}) async {
    final BaseOptions options = _baseOptions;
    if (isNotApiOrigin) {
      options.baseUrl = '';
    }
    final Dio dio = Dio(options);
    // McAppActionsInterceptor must be first.
    // Todo(suheyl): [2024-09-13 - 3_27_p_m_] Active it.
    // dio.interceptors.add(McAppActionsInterceptor());

    dio.interceptors.add(ErrorsHandlingInterceptor());

    switch (InitModel.httpLoggerLevel) {
      case LogDetails.compact:
        dio.interceptors.add(MiniLoggerInterceptor());
        break;
      case LogDetails.detailed:
        dio.interceptors.add(LoggingInterceptor());
        break;
      case LogDetails.full:
        dio.interceptors.add(
          TalkerDioLogger(
            settings: const TalkerDioLoggerSettings(
              printRequestHeaders: true,
              printResponseHeaders: true,
              printResponseMessage: true,
              printResponseData: true,
            ),
          ),
        );
        break;
      case LogDetails.none:
    }
    if (InitModel.enableCaching) {
      CacheOptions cacheOptions = await _initCacheStorage();
      dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    }

    return dio;
  }

  Future<CacheOptions> _initCacheStorage() async {
    Directory temporaryDirectory = await getTemporaryDirectory();
    String path = temporaryDirectory.path;
    HiveCacheStore cacheStore = HiveCacheStore(path);
    CacheOptions cacheOptions = CacheOptions(
      store: cacheStore as CacheStore,
    );
    return cacheOptions;
  }
}
