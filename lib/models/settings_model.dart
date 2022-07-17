import 'package:equatable/equatable.dart';
import 'difficulty_settings_model.dart';
import 'question_status_settings_model.dart';
import 'category_settings_model.dart';

class SettingsModel extends Equatable {
  final List<CategorySettingsModel> categorySettingsModelList;
  final List<DifficultySettingsModel> difficultySettingsModelList;
  final List<QuestionStatusSettingsModel> questionStatusSettingsModelList;

  const SettingsModel({
    required this.categorySettingsModelList,
    required this.difficultySettingsModelList,
    required this.questionStatusSettingsModelList,
  });

  @override
  List<Object?> get props => [
        categorySettingsModelList,
        difficultySettingsModelList,
        questionStatusSettingsModelList,
      ];
}
