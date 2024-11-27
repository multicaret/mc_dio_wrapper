import 'dart:async' show FutureOr;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mc_dio_wrapper/src/alerts/app_show_toast.dart';
import 'package:mc_dio_wrapper/src/alerts/os_native_alert_dialog.dart';
import 'package:mc_dio_wrapper/src/helpers/extensions/dio_exception_type_extension.dart';
import 'package:mc_dio_wrapper/src/helpers/extensions/string_extension.dart';
import 'package:mc_dio_wrapper/src/helpers/logger.dart';

class McDioError extends DioException {
  static String noInternetConnectionKey = 'No internet connection';
  static const int _showDialogWhenErrorsCount = 2;
  static const int _showToastWhenErrorStringLength = 80;
  bool _isLargeError = false;

  McDioError(DioException error)
      : super(
          requestOptions: error.requestOptions,
          message: error.message,
          error: error.error,
          response: error.response,
          type: error.type,
          stackTrace: error.stackTrace,
        ) {
    if (error.error != null && error.error is DioException) {
      _checkErrorsLength(error.error as DioException);
    } else {
      _checkErrorsLength(error);
    }
  }

  void _checkErrorsLength(DioException error) {
    DioException tmpErrorsObject = error;
    if (tmpErrorsObject.error is Map) {
      _isLargeError = (tmpErrorsObject.error as Map).length > _showDialogWhenErrorsCount;
    }
    if (tmpErrorsObject.error is List) {
      _isLargeError = (tmpErrorsObject.error as List).length > _showDialogWhenErrorsCount;
    }
    if (tmpErrorsObject.error is String) {
      _isLargeError = (tmpErrorsObject.error as String).length > _showToastWhenErrorStringLength;
    }
    if (tmpErrorsObject.error == null && tmpErrorsObject.message != null) {
      _isLargeError = tmpErrorsObject.message!.length > _showToastWhenErrorStringLength;
    }
  }

  @override
  String toString() {
    String msg = 'McDioError [${type.title}]: $message';
    if (error != null) {
      if (error is List) {
        List list = error as List;
        for (var errorInList in list) {
          msg += '\nError: $errorInList';
        }
      } else {
        msg += '\nError: $error';
      }
    }
    if (error != null && error is Map) {
      Map mapError = error as Map;
      mapError.values.toList().forEach((error) {
        msg += '\nError: ${error.toString()}';
      });
    }
    msg += '\nStackTrace: ${stackTrace.toString()}';
    return msg;
  }

  Set<String> _errorAttributeToString([bool withEndLine = false]) {
    Set<String> errorSet = {};
    if (error != null) {
      if (error is List) {
        List list = error as List;
        for (var errorInList in list) {
          errorSet.add('\n$errorInList');
        }
      }
      if (error is Map) {
        Map mapError = error as Map;
        errorSet = _loadErrorsFromMapErrorObject(mapError, errorSet);
      }
      if (error is DioException) {
        DioException errObject = error as DioException;
        if (errObject.error is Map) {
          Map mapError = errObject.error as Map;
          errorSet = _loadErrorsFromMapErrorObject(mapError, errorSet);
        }
      }
      if (errorSet.isEmpty) {
        errorSet.add('${withEndLine ? '\n' : ''}${error.toString()}');
      }
    } else {
      errorSet.add('Error!.');
    }
    return errorSet;
  }

  Set<String> _loadErrorsFromMapErrorObject(Map mapError, Set<String> errorBuilder) {
    for (MapEntry element in mapError.entries) {
      String inputErrorMessage = '';
      if (element.value is List) {
        final valueOfError = element.value;
        String inputErrors =
            valueOfError.map((inputErrorMsg) => '\n-${inputErrorMsg.toString()}\n').toSet().join();
        inputErrorMessage += '${element.key}:$inputErrors';
      } else {
        inputErrorMessage += '${element.key}: ${element.value.toString()}';
      }
      errorBuilder.add(inputErrorMessage);
    }
    return errorBuilder;
  }

  PackageToast toToastByMessage() {
    return PackageToast(message: message ?? response?.statusMessage ?? 'Error!.');
  }

  PackageToast toToastByErrors() {
    String msg = _errorAttributeToString().join(' ');
    if (msg.length < 3 && message != null && message!.length > 3) {
      msg = message!;
    }
    return PackageToast(message: msg);
  }

  Future<bool?> toDialogAlertByMessage(BuildContext context) {
    final String? subtitle = message ?? response?.statusMessage;
    return _toDialogAlert(context, titleKey: 'An Error occurred', subtitle: subtitle);
  }

  Future<bool?> toDialogAlertByErrors(BuildContext context,
      [bool withKeys = true, String? titleKey, String? subtitle, bool? result]) {
    Set<String> attributeToString = _errorAttributeToString();
    if (withKeys) {
      attributeToString = attributeToString.map((String e) => e.afterFirst(':')).toSet();
    }
    final content = attributeToString.join('\n');
    return _toDialogAlert(context,
        titleKey: titleKey ?? 'An Error occurred',
        subtitle: subtitle ?? message,
        content: content,
        result: result ?? false);
  }

  Future<bool?> showErrorsByWeight(BuildContext context) {
    if (_isLargeError) {
      return toDialogAlertByErrors(context);
    } else {
      return toToastByErrors().show();
    }
  }

  Future<bool?> _toDialogAlert(
    BuildContext context, {
    required String titleKey,
    String? subtitle,
    String? content,
    bool result = false,
  }) {
    return OsNativeAlertDialog<bool>(
      context: context,
      title: titleKey,
      content: '$subtitle\n$content',
      result: result,
    ).show();
  }

  static FutureOr<E?> handlerByToastMsg<E>(Object error, StackTrace? stackTrace) {
    of(error, stackTrace).toToastByMessage().show();
    return null;
  }

  static FutureOr<E?> Function(Object error, StackTrace? stackTrace) handlerByDialogByErrors<E>(
      BuildContext ctx,
      [bool withKeys = true,
      String? titleKey,
      String? subtitle]) {
    _(Object error, StackTrace? stackTrace) {
      of(error, stackTrace).toDialogAlertByErrors(ctx, withKeys, titleKey, subtitle);
    }

    return _;
  }

  static McDioError of(Object errorObject, [StackTrace? stackTrace]) {
    AppLogger().error('McDioError handler', errorObject, stackTrace);
    if (errorObject is String) {
      return McDioError._fromString(errorObject, stackTrace);
    }
    if (errorObject is DioException) {
      return McDioError(errorObject);
    }
    if (errorObject is HiveError) {
      return McDioError._fromString(errorObject.message, stackTrace);
    }
    final DioException error = DioException(
      requestOptions: RequestOptions(),
      message: errorObject.toString(),
      error: errorObject.toString(),
      response: null,
      type: DioExceptionType.badResponse,
      stackTrace: stackTrace,
    );
    return McDioError(error);
  }

  McDioError._fromString(String errorString, [StackTrace? stackTrace])
      : super(
          requestOptions: RequestOptions(),
          message: errorString,
          error: errorString,
          response: null,
          type: DioExceptionType.badResponse,
          stackTrace: null,
        );

  bool isNoInternetConnectionError() {
    final bool state = type == DioExceptionType.connectionError &&
        message != null &&
        message!.contains(McDioError.noInternetConnectionKey);
    return state;
  }
}
