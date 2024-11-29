import 'package:flutter/material.dart';
import 'package:kudu/app/ui/colors.dart';

abstract class UiTheme {
  static const String _font = "Poppins";
  static final ThemeData light = ThemeData(
      fontFamily: _font,
      bottomSheetTheme: const BottomSheetThemeData(
          modalBackgroundColor: Colors.white, backgroundColor: Colors.white),
      appBarTheme:
          const AppBarTheme(elevation: 0, backgroundColor: Colors.white),
      scaffoldBackgroundColor: Colors.white,
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
        side: WidgetStateBorderSide.resolveWith(
            (_) => const BorderSide(color: AppUiColor.primary)),
        textStyle: WidgetStateProperty.resolveWith<TextStyle>((_) => TextStyle(
              fontSize: 15,
              foreground: Paint()..color = AppUiColor.primary,
              fontFamily: _font,
              fontWeight: FontWeight.w500,
            )),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.resolveWith<Size>(
              (_) => const Size(double.infinity, 55)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor:
              WidgetStateProperty.resolveWith<Color>((_) => AppUiColor.primary),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
          textStyle:
              WidgetStateProperty.resolveWith<TextStyle>((_) => TextStyle(
                    fontSize: 15,
                    foreground: Paint()..color = Colors.white,
                    fontFamily: _font,
                    fontWeight: FontWeight.w500,
                  )),
        ),
      ));
}
