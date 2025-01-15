import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToast({
  required String message,
  Color? backgroundColor,
  Color? textColor,
  double fontSize = 14.0,
}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}

Future<bool?> cancelToasts() {
  return Fluttertoast.cancel();
}
