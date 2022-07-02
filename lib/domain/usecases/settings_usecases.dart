import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../../models/settings_model.dart';

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

  Future<Either<Failure, int>> toggleAskDifficulty(
      {required int difficultyAsInt}) {
    return settingsRepository.toggleAskDifficulty(
        difficultyAsInt: difficultyAsInt);
  }
}
