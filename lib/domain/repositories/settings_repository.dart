import 'package:dartz/dartz.dart';
import 'package:nebilimapp/domain/failures/failures.dart';
import 'package:nebilimapp/models/settings_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SettingsModel>> getAllSettings();
  Future<Either<Failure, int>> toggleAskCategory({required int categoryAsInt});
}
