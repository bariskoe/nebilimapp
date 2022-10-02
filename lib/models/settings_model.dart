import 'package:equatable/equatable.dart';
import 'thinking_time_model.dart';
import 'difficulty_settings_model.dart';
import 'question_status_settings_model.dart';
import 'category_settings_model.dart';

class SettingsModel extends Equatable {
  final List<CategorySettingsModel> categorySettingsModelList;
  final List<DifficultySettingsModel> difficultySettingsModelList;
  final List<QuestionStatusSettingsModel> questionStatusSettingsModelList;
  final ThinkingTimeModel thinkingTimeModel;
  final bool textToSpeechOn;
  final bool chainQuestionsOn;
  final int restingTime;

  const SettingsModel({
    required this.categorySettingsModelList,
    required this.difficultySettingsModelList,
    required this.questionStatusSettingsModelList,
    required this.thinkingTimeModel,
    required this.textToSpeechOn,
    required this.restingTime,
    required this.chainQuestionsOn,
  });

  @override
  List<Object?> get props => [
        categorySettingsModelList,
        difficultySettingsModelList,
        questionStatusSettingsModelList,
        thinkingTimeModel,
        textToSpeechOn,
        restingTime,
        chainQuestionsOn,
      ];
}
