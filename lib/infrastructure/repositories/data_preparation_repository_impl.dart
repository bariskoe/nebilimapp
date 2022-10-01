import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/failures/failures.dart';
import '../../domain/repositories/data_preparation_repository.dart';
import '../datasources/local_sqlite_datasource.dart';

class DataPreparationRepositoryImpl implements DataPreparationRepository {
  final LocalSqliteDataSource localSqliteDataSource;
  DataPreparationRepositoryImpl({
    required this.localSqliteDataSource,
  });

  @override
  Future<Either<Failure, bool>> updateQuestionDatabaseIfNeccessary() async {
    try {
      final updated =
          await localSqliteDataSource.updateQuestionDatabaseIfNeccessary();
      return Right(updated);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Database>> initializeSettingsDatabase() async {
    try {
      final settingsDatabase =
          await localSqliteDataSource.functionToInitializeSettingsDatabase();
      return Right(settingsDatabase);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
