import 'package:flutter/material.dart';
import 'pages/settings_page.dart';
import 'pages/data_preparation_page.dart';
import 'pages/single_quiz_page.dart';

class Routing {
  static String get dataPreparationPage => '/dataPreparationPage';

  static String get singleQuizPage => '/singleQuizPage';
  static String get settingsPage => '/settingsPage';

  static Map<String, Widget Function(BuildContext)> routes = {
    dataPreparationPage: (context) => const DataPreparationPage(),
    singleQuizPage: (context) => const SingleQuizPage(),
    settingsPage: (context) => const SettingsPage(),
  };
}
