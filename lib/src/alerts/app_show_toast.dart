import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PackageToast {
  final BuildContext? _context;
  late final String _msg;
  late final Toast _length;
  late final ToastGravity _gravity;
  late final int _timeInSec;

  PackageToast({
    required String message,
    bool? isShortToast,
    bool? isLocalized,
    ToastGravity? gravity,
    int? timeInSecForIosWeb,
    BuildContext? context,
  })  : _context = context,
        _msg = message,
        _length = isShortToast == true ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
        _gravity = gravity ?? ToastGravity.CENTER,
        _timeInSec = timeInSecForIosWeb ?? 1;

  factory PackageToast.of(
    BuildContext context, {
    required String message,
    bool? isShortToast,
    bool? isLocalized,
    ToastGravity? gravity,
    int? timeInSecForIosWeb,
  }) {
    return PackageToast(
      context: context,
      message: message,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      isShortToast: isShortToast,
    );
  }

  Future<bool?> show() async {
    return Fluttertoast.showToast(
      msg: _msg,
      toastLength: _length,
      gravity: _gravity,
      timeInSecForIosWeb: _timeInSec,
      backgroundColor: isBrightness == Brightness.dark
          ? Colors.white.withOpacity(0.9)
          : Colors.black.withOpacity(0.9),
      textColor: isBrightness == Brightness.dark ? Colors.black : Colors.white,
      fontSize: 16,
      // Todo(suheyl): [2024-09-13 - 3_15_p_m_] Work on web attributes
      // webBgColor: ,webPosition: ,webShowClose:
    );
  }

  Brightness? get isBrightness {
    if (_context != null && _context.mounted) {
      return Theme.of(_context).brightness;
    }
    return null;
  }

  static Future<bool?> cancel() {
    return Fluttertoast.cancel();
  }

  @override
  String toString() {
    return "Message: $_msg";
  }
}
