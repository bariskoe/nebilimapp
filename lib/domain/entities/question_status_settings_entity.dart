import '../../database/settings_database_helper.dart';
import '../../models/question_status_settings_model.dart';
import 'question_status_entity.dart';

class QuestionStatusSettingsEntity {
  String questionStatusName;
  int ask;

  QuestionStatusSettingsEntity({
    required this.questionStatusName,
    required this.ask,
  });

  QuestionStatusSettingsModel toModel() {
    QuestionStatus questionStatus =
        QuestionStatusExtension.fromName(name: questionStatusName);

    return QuestionStatusSettingsModel(
      questionStatus: questionStatus,
      ask: ask == 0 ? false : true,
    );
  }

  static QuestionStatusSettingsEntity fromMap(Map<String, dynamic> map) {
    return QuestionStatusSettingsEntity(
        questionStatusName:
            map[SettingsDatabaseHelper.otherSettingsTableFieldNameOfSetting],
        ask: map[SettingsDatabaseHelper.otherSettingsTableFieldValueAsInt]);
  }
}
