import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../../models/settings_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SettingsModel>> getAllSettings();
  Future<Either<Failure, int>> toggleAskCategory({required int categoryAsInt});
  Future<Either<Failure, int>> toggleAskDifficulty(
      {required int difficultyAsInt});
  Future<Either<Failure, int>> toggleAskMarkedAs({required String statusName});
}
