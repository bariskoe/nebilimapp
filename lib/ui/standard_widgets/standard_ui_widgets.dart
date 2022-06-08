import 'package:flutter/material.dart';

import '../ui_constants/ui_constants.dart';

class StandardUiWidgets {
  static standardBoxDecoration(
      {required BuildContext context,
      List<Color>? gradientcolors,
      bool shadowOn = true,
      String? imagePath}) {
    return BoxDecoration(
        image: imagePath != null
            ? DecorationImage(
                image: AssetImage(imagePath), fit: BoxFit.cover, opacity: 0.1)
            : null,
        gradient: gradientcolors != null
            ? LinearGradient(colors: gradientcolors)
            : null,
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(UiConstantsRadius.regular),
        boxShadow: shadowOn ? standardBoxShadow() : []);
  }

  static standardBoxShadow() {
    return [
      BoxShadow(
          blurRadius: 5,
          color: Colors.black.withOpacity(0.5),
          offset: const Offset(5, 3))
    ];
  }
}
