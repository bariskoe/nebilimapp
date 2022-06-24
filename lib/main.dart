import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/data_preparation_bloc/data_preparation_bloc.dart';
import 'bloc/question_bloc/bloc/question_bloc.dart';
import 'bloc/settings_bloc/bloc/settings_bloc.dart';
import 'dependency_injection.dart' as di;
import 'dependency_injection.dart';
import 'pages/data_preparation_page.dart';
import 'routing.dart';
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
        BlocProvider(create: (context) => getIt<QuestionBloc>()),
        BlocProvider(create: (context) => getIt<SettingsBloc>()),
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
