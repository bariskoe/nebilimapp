import 'package:flutter/material.dart';
import 'package:nebilimapp/custom_widgets/standard_page_widget.dart';
import 'package:nebilimapp/ui/themes/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo', theme: Themes.greentheme(), home: Testpage());
  }
}

class Testpage extends StatelessWidget {
  const Testpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StandardPageWidget(
      appBarTitle: 'Nebilim',
      child: Text(
        'Test. Hier sehe ich, wie groß der text ist',
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
