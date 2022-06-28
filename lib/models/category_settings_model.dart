import 'package:equatable/equatable.dart';
import 'package:nebilimapp/database/settings_database_helper.dart';
import 'package:nebilimapp/models/question_insertion_model.dart';

class CategorySettingsModel with EquatableMixin {
  QuestionCategory questionCategory;
  bool ask;

  CategorySettingsModel({
    required this.questionCategory,
    required this.ask,
  });

  @override
  List<Object?> get props => [
        questionCategory,
        ask,
      ];

  // Map<String, dynamic> toMap() {
  //   return {

  //   };
  // }

  // CategorySettingsModel fromMap(Map<String, dynamic> map) {
  //   return CategorySettingsModel(
  //     askHistory: map[SettingsDatabaseHelper.categorySettingsTableFieldHistory],
  //     askGeography:
  //         map[SettingsDatabaseHelper.categorySettingsTableFieldGeography],
  //     askScience: map[SettingsDatabaseHelper.categorySettingsTableFieldScience],
  //     askSports: map[SettingsDatabaseHelper.categorySettingsTableFieldSports],
  //     askMedicine:
  //         map[SettingsDatabaseHelper.categorySettingsTableFieldMedicine],
  //     askLiterature:
  //         map[SettingsDatabaseHelper.categorySettingsTableFieldLiterature],
  //     askCelebrities:
  //         map[SettingsDatabaseHelper.categorySettingsTableFieldCelebrities],
  //     askFood: map[SettingsDatabaseHelper.categorySettingsTableFieldFood],
  //     askMusic: map[SettingsDatabaseHelper.categorySettingsTableFieldMusic],
  //     askArts: map[SettingsDatabaseHelper.categorySettingsTableFieldArts],
  //   );
  // }
}
