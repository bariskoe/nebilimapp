import 'package:flutter/material.dart';

class Themes {
  static TextTheme appTextTheme() {
    const String fontFamiliy = 'Cherry Swash';

    return const TextTheme(
        headline1: TextStyle(
            fontSize: 36, fontWeight: FontWeight.bold, fontFamily: fontFamiliy),
        headline2: TextStyle(
            fontSize: 72.0,
            fontStyle: FontStyle.italic,
            fontFamily: fontFamiliy),
        bodyText2: TextStyle(fontSize: 20.0, fontFamily: fontFamiliy),
        bodyText1: TextStyle(fontSize: 20.0, fontFamily: fontFamiliy),
        subtitle1: TextStyle(fontSize: 12.0, fontFamily: fontFamiliy));
  }

  static ThemeData greentheme() {
    const double opacity = 1;
    const Color primary = Color.fromRGBO(27, 84, 4, opacity);
    const Color onPrimary = Color.fromRGBO(255, 255, 255, opacity);
    const Color secondary = Color.fromRGBO(9, 64, 36, opacity);
    const Color onSecondary = Color.fromRGBO(255, 255, 255, opacity);
    const Color error = Color.fromRGBO(214, 28, 11, opacity);
    const Color onError = Color.fromRGBO(255, 255, 255, opacity);
    const Color background = Color.fromRGBO(245, 240, 240, opacity);
    const Color onBackground = Color.fromRGBO(38, 37, 37, opacity);
    const Color surface = Color.fromRGBO(250, 250, 250, opacity);
    const Color onSurface = Color.fromRGBO(38, 37, 37, opacity);

    return ThemeData(
        textTheme: appTextTheme(),
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: primary,
            onPrimary: onPrimary,
            secondary: secondary,
            onSecondary: onSecondary,
            error: error,
            onError: onError,
            background: background,
            onBackground: onBackground,
            surface: surface,
            onSurface: onSurface));
  }
}
