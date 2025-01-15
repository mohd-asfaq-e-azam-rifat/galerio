import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galerio/constants.dart';

final lightTheme = ThemeData(
  fontFamily: fontFamilyRoboto,
  primaryColor: colorPrimary,
  appBarTheme: _appBarTheme,
  scaffoldBackgroundColor: Colors.white,
  textSelectionTheme: _textSelectionTheme,
  elevatedButtonTheme: _elevatedButtonThemeData,
  brightness: Brightness.light,
  bottomSheetTheme: _bottomSheetThemeData,
  dialogTheme: _dialogThemeData,
  useMaterial3: false,
);

const _appBarTheme = AppBarTheme(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  ),
);

const _textSelectionTheme = TextSelectionThemeData(
  selectionHandleColor: Colors.transparent,
  cursorColor: colorPrimary,
);

final _elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    overlayColor: WidgetStateProperty.all<Color>(
      Colors.white.withValues(alpha: 0.1),
    ),
    shape: WidgetStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(31.0),
        side: BorderSide(color: colorLightGreen),
      ),
    ),
  ),
);

const _bottomSheetThemeData = BottomSheetThemeData(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(4.0),
      topLeft: Radius.circular(4.0),
    ),
  ),
);

const _dialogThemeData = DialogTheme(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(4.0),
    ),
  ),
);
