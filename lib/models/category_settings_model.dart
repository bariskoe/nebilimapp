import 'package:equatable/equatable.dart';
import 'package:nebilimapp/database/settings_database_helper.dart';
import 'package:nebilimapp/models/question_insertion_model.dart';

class CategorySettingsModel extends Equatable {
  final bool askHistory;
  final bool askGeography;
  final bool askScience;
  final bool askSports;
  final bool askMedicine;
  final bool askLiterature;
  final bool askCelebrities;
  final bool askFood;
  final bool askMusic;
  final bool askArts;

  const CategorySettingsModel({
    required this.askHistory,
    required this.askGeography,
    required this.askScience,
    required this.askSports,
    required this.askMedicine,
    required this.askLiterature,
    required this.askCelebrities,
    required this.askFood,
    required this.askMusic,
    required this.askArts,
  });

  @override
  List<Object?> get props => [
        askHistory,
        askGeography,
        askScience,
        askSports,
        askMedicine,
        askLiterature,
        askCelebrities,
        askFood,
        askMusic,
        askArts,
      ];

  Map<String, dynamic> toMap() {
    return {
      SettingsDatabaseHelper.categorySettingsTableFieldHistory: askHistory,
      SettingsDatabaseHelper.categorySettingsTableFieldGeography: askGeography,
      SettingsDatabaseHelper.categorySettingsTableFieldScience: askScience,
      SettingsDatabaseHelper.categorySettingsTableFieldSports: askSports,
      SettingsDatabaseHelper.categorySettingsTableFieldMedicine: askMedicine,
      SettingsDatabaseHelper.categorySettingsTableFieldLiterature:
          askLiterature,
      SettingsDatabaseHelper.categorySettingsTableFieldCelebrities:
          askCelebrities,
      SettingsDatabaseHelper.categorySettingsTableFieldFood: askFood,
      SettingsDatabaseHelper.categorySettingsTableFieldMusic: askMusic,
      SettingsDatabaseHelper.categorySettingsTableFieldArts: askArts,
    };
  }

  CategorySettingsModel fromMap(Map<String, dynamic> map) {
    return CategorySettingsModel(
      askHistory: map[SettingsDatabaseHelper.categorySettingsTableFieldHistory],
      askGeography:
          map[SettingsDatabaseHelper.categorySettingsTableFieldGeography],
      askScience: map[SettingsDatabaseHelper.categorySettingsTableFieldScience],
      askSports: map[SettingsDatabaseHelper.categorySettingsTableFieldSports],
      askMedicine:
          map[SettingsDatabaseHelper.categorySettingsTableFieldMedicine],
      askLiterature:
          map[SettingsDatabaseHelper.categorySettingsTableFieldLiterature],
      askCelebrities:
          map[SettingsDatabaseHelper.categorySettingsTableFieldCelebrities],
      askFood: map[SettingsDatabaseHelper.categorySettingsTableFieldFood],
      askMusic: map[SettingsDatabaseHelper.categorySettingsTableFieldMusic],
      askArts: map[SettingsDatabaseHelper.categorySettingsTableFieldArts],
    );
  }
}
