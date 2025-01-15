import 'package:flutter/material.dart';
import 'package:galerio/base/widget/loader/base_data_loader.dart';
import 'package:galerio/constants.dart';
import 'package:galerio/ui/extensions.dart';

class BaseFilledButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color textColor;
  final Color backgroundColor;
  final Color progressColor;
  final bool isLoading;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? fontSize;
  final EdgeInsets? margin;

  const BaseFilledButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.textColor = colorText1,
    this.backgroundColor = colorLightGreen,
    this.progressColor = colorText1,
    this.isLoading = false,
    this.buttonWidth,
    this.buttonHeight,
    this.fontSize = 16.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = Theme.of(context).elevatedButtonTheme.style;

    return isLoading
        ? Container(
            width: buttonWidth,
            height: buttonHeight,
            margin: margin,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(31.0),
            ),
            child: Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: BaseDataLoader(
                  customColor: progressColor,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          )
        : Container(
            width: buttonWidth,
            height: buttonHeight,
            margin: margin,
            child: ElevatedButton(
              onPressed: onPressed != null
                  ? () {
                      context.hideKeyboard();
                      onPressed!.call();
                    }
                  : null,
              style: buttonStyle?.copyWith(
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return colorDisabled2;
                    } else {
                      return textColor;
                    }
                  },
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return colorDisabled1;
                    } else {
                      return backgroundColor;
                    }
                  },
                ),
                textStyle: WidgetStateProperty.all<TextStyle?>(
                  TextStyle(
                    fontFamily: fontFamilyRoboto,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize,
                    height: 1.172,
                  ),
                ),
              ),
              child: Text(title),
            ),
          );
  }
}
