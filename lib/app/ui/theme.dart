import 'package:flutter/material.dart';
import 'package:kudu/app/ui/colors.dart';

abstract class AppTheme {
  static const String _font = "Poppins";
  static final ThemeData light = ThemeData(
      fontFamily: _font,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.resolveWith<Size>(
              (_) => const Size(double.infinity, 55)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor:
              WidgetStateProperty.resolveWith<Color>((_) => AppColor.primary),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
          textStyle:
              WidgetStateProperty.resolveWith<TextStyle>((_) => TextStyle(
                    fontSize: 16,
                    foreground: Paint()..color = Colors.white,
                    fontFamily: _font,
                    fontWeight: FontWeight.w500,
                  )),
        ),
      ));
}
