 import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';




final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xFFFCF8FF),
  primarySwatch: Colors.blue,
  fontFamily: 'Inter',
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6F2A8C),
    primary: AppColor.primaryColor,
    secondary: AppColor.secondaryColor,
  ),
  snackBarTheme:  SnackBarThemeData(
    backgroundColor: AppColor.primaryColor,
    contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF0EDF6),
    hintStyle: const TextStyle(color: Color(0xFF6F6F74), fontSize: 18),
    contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    border: InputBorder.none,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    ),
    activeIndicatorBorder:BorderSide(color: Color(0xFFF0EDF6)),
    focusedErrorBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFF0EDF6))
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF6F2A8C), width: 1.2),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.circular(8),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xFFF0EDF6))
    )
  ),
  useMaterial3: false,
);
