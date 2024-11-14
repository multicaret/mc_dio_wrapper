import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class OsNativeAlertDialog<T extends Object> {
  final bool _isIos = Platform.isIOS;
  final BuildContext context;
  final String title;
  final String? content;
  final T? result;
  final bool isConfirm;
  final bool isDestructive;
  final bool useRootNavigator;
  final bool barrierDismissible;
  final RouteSettings? routeSettings;
  final String positiveActionLabel;
  final String negativeActionLabel;
  final Color destructiveColor;

  factory OsNativeAlertDialog.confirm(BuildContext context, String title, T result,
      [String? content]) {
    return OsNativeAlertDialog(
      context: context,
      title: title,
      content: content,
      result: result,
      isConfirm: true,
    );
  }

  factory OsNativeAlertDialog.destructiveConfirm(BuildContext context, String title, T result,
      [String? content, String positiveActionLabel = 'Delete']) {
    return OsNativeAlertDialog(
      context: context,
      title: title,
      content: content,
      result: result,
      isDestructive: true,
      isConfirm: true,
      positiveActionLabel: positiveActionLabel,
    );
  }

  OsNativeAlertDialog({
    required this.context,
    required this.title,
    this.content,
    this.result,
    this.isConfirm = false,
    this.isDestructive = false,
    this.useRootNavigator = true,
    this.barrierDismissible = false,
    this.routeSettings,
    this.positiveActionLabel = 'OK',
    this.negativeActionLabel = 'Cancel',
    this.destructiveColor = Colors.red,
  });

  Future<T?> show() {
    if (_isIos) {
      return _showIosDialog();
    }
    return _showAndroidDialog();
  }

  Future<T?> _showIosDialog() {
    return showCupertinoDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      builder: (BuildContext context) {
        final Widget titleWidget = Text(title);
        final Widget contentsWidget = Text(content ?? '');
        final Widget confirmButtonWidget = CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: isDestructive,
          onPressed: _popWithResult,
          child: Text(_positiveLabel),
        );
        final Widget normalButtonWidget = CupertinoDialogAction(
          onPressed: _pop,
          child: Text(_cancelBtnLabel),
        );
        List<Widget> actions = [normalButtonWidget, confirmButtonWidget];
        if (!isConfirm) {
          actions.removeAt(0);
        }
        return CupertinoAlertDialog(
          title: titleWidget,
          content: contentsWidget,
          actions: actions,
        );
      },
    );
  }

  Future<T?> _showAndroidDialog() {
    return showDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      builder: (BuildContext context) {
        ButtonStyle? buttonStyle;
        if (isDestructive) {
          buttonStyle = TextButton.styleFrom(foregroundColor: destructiveColor);
        }
        Widget titleWidget = Text(title);
        Widget contentsWidget = Text(content ?? '');
        Widget confirmButtonWidget = TextButton(
          style: buttonStyle,
          onPressed: _popWithResult,
          child: Text(_positiveLabel),
        );
        Widget normalButtonWidget = TextButton(
          onPressed: _pop,
          child: Text(_cancelBtnLabel),
        );
        List<Widget> actions = [normalButtonWidget, confirmButtonWidget];
        if (!isConfirm) {
          actions.removeAt(0);
        }
        return AlertDialog(
          title: titleWidget,
          content: contentsWidget,
          actions: actions,
        );
      },
    );
  }

  String get _positiveLabel {
    if (isConfirm && !isDestructive) return 'Yes';
    return positiveActionLabel;
  }

  String get _cancelBtnLabel {
    if (isConfirm && !isDestructive) return 'No';
    return negativeActionLabel;
  }

  void _popWithResult() => Navigator.pop<T>(context, result);

  void _pop() => Navigator.pop<T>(context);
}
