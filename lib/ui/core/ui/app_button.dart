
import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';



class AppButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final double? fontSize;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Widget? child;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    this.text,
    this.onPressed,
    this.fontSize,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColor.primaryColor,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: fontSize != null ? TextStyle(fontSize: fontSize) : null,
        ),
        onPressed: onPressed,
        child: child ??
            Text(
              text ?? '',
              style: TextStyle(color: textColor ?? Colors.white),
            ),
      ),
    );
  }
}

