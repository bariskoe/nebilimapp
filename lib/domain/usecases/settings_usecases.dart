import 'package:dartz/dartz.dart';
import 'package:nebilimapp/domain/failures/failures.dart';
import 'package:nebilimapp/models/settings_model.dart';

import '../repositories/settings_repository.dart';

class SettingsUsecases {
  SettingsRepository settingsRepository;

  SettingsUsecases({
    required this.settingsRepository,
  });

  Future<Either<Failure, SettingsModel>> getAllSettings() {
    return settingsRepository.getAllSettings();
  }

  Future<Either<Failure, int>> toggleAskCategory({required int categoryAsInt}) {
    return settingsRepository.toggleAskCategory(categoryAsInt: categoryAsInt);
  }
}
