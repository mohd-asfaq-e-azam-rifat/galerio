import 'package:flutter/material.dart';
import 'package:galerio/constants.dart';

class BaseDataLoader extends StatelessWidget {
  final Color? customColor;
  final double strokeWidth;

  const BaseDataLoader({
    super.key,
    this.customColor,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(
        customColor ?? colorPrimary,
      ),
    );
  }
}
