import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nebilimapp/bloc/bloc/data_preparation_bloc.dart';
import 'package:nebilimapp/dependency_injection.dart' as di;
import 'package:nebilimapp/pages/data_preparation_page.dart';
import 'package:nebilimapp/routing.dart';

import 'dependency_injection.dart';
import 'pages/single_quiz_page.dart';
import 'ui/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupDependencyInjectionWithGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<DataPreparationBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nebilim Quiz App',
        theme: Themes.greentheme(),
        home: const DataPreparationPage(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('de', ''),
        ],
        routes: Routing.routes,
      ),
    );
  }
}
