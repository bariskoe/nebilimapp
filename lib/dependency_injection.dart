import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/animation_bloc/bloc/animation_bloc.dart';
import 'bloc/data_preparation_bloc/data_preparation_bloc.dart';
import 'bloc/question_bloc/bloc/question_bloc.dart';
import 'bloc/settings_bloc/bloc/settings_bloc.dart';
import 'bloc/text_to_speech_bloc/bloc/text_to_speech_bloc.dart';
import 'domain/repositories/data_preparation_repository.dart';
import 'domain/repositories/question_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/shared_prefs_repository.dart';
import 'domain/usecases/data_preparation_usecases.dart';
import 'domain/usecases/question_usecases.dart';
import 'domain/usecases/settings_usecases.dart';
import 'domain/usecases/sharedprefs_usecases.dart';
import 'infrastructure/datasources/local_sqlite_datasource.dart';
import 'infrastructure/datasources/local_sqlite_datasource_impl.dart';
import 'infrastructure/datasources/shared_prefs_datasource.dart';
import 'infrastructure/datasources/shared_prefs_datasource_impl.dart';
import 'infrastructure/repositories/data_preparation_repository_impl.dart';
import 'infrastructure/repositories/question_repository_impl.dart';
import 'infrastructure/repositories/settings_repository_impl.dart';
import 'infrastructure/repositories/shared_prefs_repository_impl.dart';

final getIt = GetIt.I;

Future<void> setupDependencyInjectionWithGetIt() async {
//! application layer

  getIt.registerLazySingleton(() => DataPreparationBloc(
        dataPreparationUsecases: getIt(),
      ));
  getIt.registerLazySingleton(() => QuestionBloc(
        questionUsecases: getIt(),
        animationBloc: getIt(),
        textToSpeechBloc: getIt(),
        settingsBloc: getIt(),
      ));

  getIt.registerLazySingleton(() => SettingsBloc(
        settingsUsecases: getIt(),
      ));

  getIt.registerLazySingleton(() => AnimationBloc(
        settingsBloc: getIt(),
      ));
  getIt.registerLazySingleton(() => TextToSpeechBloc(
        flutterTts: getIt(),
      ));
//! Usecases

  getIt.registerLazySingleton(
    () => SharedPrefsUsecases(
      sharedPrefsRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton(
      () => DataPreparationUsecases(dataPreparationRepository: getIt()));

  getIt.registerLazySingleton(() => QuestionUsecases(
        questionRepository: getIt(),
      ));
  getIt.registerLazySingleton(() => SettingsUsecases(
        settingsRepository: getIt(),
      ));

//! repos
  getIt.registerLazySingleton<SharePrefsRepository>(
    () => SharedPrefsRepositoryImpl(
      sharedPrefsDatasource: getIt(),
    ),
  );

  getIt.registerLazySingleton<DataPreparationRepository>(
    () => DataPreparationRepositoryImpl(
      localSqliteDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<QuestionRepository>(() => QuestionRepositoryImpl(
        localSqliteDataSource: getIt(),
      ));

  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(
        localSqliteDataSource: getIt(),
      ));

//! Datasources
  getIt.registerLazySingleton<LocalSqliteDataSource>(
      () => LocalSqliteDataSourceImpl());

  getIt.registerLazySingleton<SharedPrefsDatasource>(
      () => SharedPrefsDatasourceImpl(
            sharedPreferences: getIt(),
          ));
//! 3rd party libraries
  getIt.registerSingleton(await SharedPreferences.getInstance());

  // Text to speech
  FlutterTts flutterTts = FlutterTts();
  getIt.registerSingleton(flutterTts);
}
