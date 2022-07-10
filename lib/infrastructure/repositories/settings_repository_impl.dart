import 'package:logger/logger.dart';
import '../../domain/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_sqlite_datasource.dart';
import '../../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final LocalSqliteDataSource localSqliteDataSource;

  SettingsRepositoryImpl({required this.localSqliteDataSource});

  @override
  Future<Either<Failure, SettingsModel>> getAllSettings() async {
    try {
      SettingsModel settingsModel =
          await localSqliteDataSource.getAllSettings();
      return Right(settingsModel);
    } catch (e) {
      Logger().e('Error caught in SettingsRepositoryImpl getAllSettings(): $e');
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> toggleAskCategory(
      {required int categoryAsInt}) async {
    try {
      int changesMade = await localSqliteDataSource.toggleAskCategory(
          categoryAsInt: categoryAsInt);
      return Right(changesMade);
    } catch (e) {
      Logger()
          .e('Error caught in SettingsRepositoryImpl toggleAskCategory: $e');
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> toggleAskDifficulty(
      {required int difficultyAsInt}) async {
    try {
      int changesMade = await localSqliteDataSource.toggleAskDifficulty(
          difficultyAsInt: difficultyAsInt);
      return Right(changesMade);
    } catch (e) {
      Logger()
          .e('Error caught in SettingsRepositoryImpl toggleAskDifficulty: $e');
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> toggleAskMarkedAs(
      {required String statusName}) async {
    try {
      int changesMade =
          await localSqliteDataSource.toggleAskMarkedAs(statusName: statusName);
      return Right(changesMade);
    } catch (e) {
      Logger()
          .e('Error caught in SettingsRepositoryImpl toggleAskMarkedAs: $e');
      return Left(DatabaseFailure());
    }
  }
}
