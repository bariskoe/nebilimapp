import 'package:equatable/equatable.dart';
import 'package:nebilimapp/models/difficulty_settings_model.dart';
import 'category_settings_model.dart';

class SettingsModel extends Equatable {
  final List<CategorySettingsModel> categorySettingsModelList;
  final List<DifficultySettingsModel> difficultySettingsModelList;

  const SettingsModel(
      {required this.categorySettingsModelList,
      required this.difficultySettingsModelList});

  @override
  List<Object?> get props => [
        categorySettingsModelList,
        difficultySettingsModelList,
      ];
}
