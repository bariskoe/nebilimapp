import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infrastructure/datasources/local_sqlite_datasource.dart';
import 'infrastructure/datasources/local_sqlite_datasource_impl.dart';

final getIt = GetIt.I;

Future<void> setupDependencyInjectionWithGetIt() async {
//! application layer

//! Usecases

//! repos

  //getIt.registerLazySingleton<LocalSqliteDataSource>(
  //    () => LocalSqliteDataSourceImpl());

  //getIt.registerLazySingleton(() => TodosBlocBloc());
  getIt.registerSingleton(await SharedPreferences.getInstance());
}
