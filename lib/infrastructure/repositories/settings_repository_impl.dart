import 'package:logger/logger.dart';
import 'package:nebilimapp/domain/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:nebilimapp/domain/repositories/settings_repository.dart';
import 'package:nebilimapp/infrastructure/datasources/local_sqlite_datasource.dart';
import 'package:nebilimapp/models/settings_model.dart';

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
      Logger().e('Error caught in SettingsRepositoryImpl: $e');
      return Left(DatabaseFailure());
    }
  }
}
