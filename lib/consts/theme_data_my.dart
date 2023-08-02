import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      //0A1931 // white yellow 0xffffffff
      scaffoldBackgroundColor:
          isDarkTheme ? const Color(0xff00000a) : const Color(0xffFFFFFF),
      primaryColor: Colors.blue,
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary:
                isDarkTheme ? const Color(0xFF1a1f3c) : const Color(0xFFE8FDFD),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      cardColor:
          isDarkTheme ? const Color(0xFF0a0d2c) : const Color(0xFFF2FDFD),
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark()
                : const ColorScheme.light(),
          ),
    );
  }
}
