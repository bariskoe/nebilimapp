import 'package:flutter/material.dart';

class Themes {
  //! Construct a dark Theme
  //! If possible, create a function which takes a primarycolor and returns a theme with
  //! the respective other colors
  static TextTheme appTextTheme() {
    const String fontFamiliy = 'Cherry Swash';

    return const TextTheme(
      displayLarge: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, fontFamily: fontFamiliy),
      displayMedium: TextStyle(
          fontSize: 22.0, fontStyle: FontStyle.normal, fontFamily: fontFamiliy),
      displaySmall: TextStyle(fontSize: 20.0, fontFamily: fontFamiliy),
      headlineMedium: TextStyle(
          fontSize: 26.0,
          fontFamily: fontFamiliy,
          fontWeight: FontWeight.w600,
          letterSpacing: 5),
      bodyLarge: TextStyle(fontSize: 20.0, fontFamily: fontFamiliy),
      bodyMedium: TextStyle(fontSize: 24.0, fontFamily: fontFamiliy),
      titleMedium: TextStyle(fontSize: 14.0, fontFamily: fontFamiliy),
    );
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
    const Color tertiary = Color.fromRGBO(224, 224, 224, opacity);
    const Color primaryContainer = Color.fromRGBO(242, 255, 230, opacity);

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
            onSurface: onSurface,
            tertiary: tertiary,
            primaryContainer: primaryContainer));
  }
}
