import 'dart:io';

import 'package:mc_dio_wrapper/mc_dio_wrapper.dart';

import 'base_response.dart';

abstract interface class HttpServiceContract {
  Future<McResponse<E>> get<E extends BaseResponse>(
    String endpoint, {
    required JsonDecoderCallback<E> converter,
    RequestQueryParams? queryParameters,
    bool hasToken = false,
  });

  Future<McResponse<E>> post<E extends BaseResponse>(
    String endpoint, {
    required JsonDecoderCallback<E> converter,
    RequestQueryParams? queryParameters,
    List<File>? galleryFiles,
    HttpRequestPayload? payload,
    bool hasToken = false,
  });

  // Todo: 2023-04-22 - 8:39 a.m. - Work on it
  // Future<dynamic> put();

  Future<McResponse<E>> delete<E extends BaseResponse>(
    String endpoint, {
    required JsonDecoderCallback<E> converter,
    RequestQueryParams? queryParameters,
    bool hasToken = false,
  });
}
