import 'package:get_it/get_it.dart';
import 'package:nebilimapp/bloc/bloc/data_preparation_bloc.dart';
import 'package:nebilimapp/domain/repositories/data_preparation_repository.dart';
import 'package:nebilimapp/domain/repositories/shared_prefs_repository.dart';
import 'package:nebilimapp/domain/usecases/data_preparation_usecases.dart';
import 'package:nebilimapp/domain/usecases/sharedprefs_usecases.dart';
import 'package:nebilimapp/infrastructure/datasources/shared_prefs_datasource.dart';
import 'package:nebilimapp/infrastructure/datasources/shared_prefs_datasource_impl.dart';
import 'package:nebilimapp/infrastructure/repositories/data_preparation_repository_impl.dart';
import 'package:nebilimapp/infrastructure/repositories/shared_prefs_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infrastructure/datasources/local_sqlite_datasource.dart';
import 'infrastructure/datasources/local_sqlite_datasource_impl.dart';

final getIt = GetIt.I;

Future<void> setupDependencyInjectionWithGetIt() async {
//! application layer

  getIt.registerLazySingleton(() => DataPreparationBloc(
        dataPreparationUsecases: getIt(),
      ));

//! Usecases

  getIt.registerLazySingleton(
    () => SharedPrefsUsecases(
      sharedPrefsRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton(
      () => DataPreparationUsecases(dataPreparationRepository: getIt()));

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

//! Datasources
  getIt.registerLazySingleton<LocalSqliteDataSource>(
      () => LocalSqliteDataSourceImpl());

  getIt.registerLazySingleton<SharedPrefsDatasource>(
      () => SharedPrefsDatasourceImpl(
            sharedPreferences: getIt(),
          ));
//! 3rd party libraries
  getIt.registerSingleton(await SharedPreferences.getInstance());
}
