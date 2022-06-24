import 'package:nebilimapp/models/category_settings_model.dart';

import '../../database/settings_database_helper.dart';

class CategorySettingsEntity {
  final int askHistory;
  final int askGeography;
  final int askScience;
  final int askSports;
  final int askMedicine;
  final int askLiterature;
  final int askCelebrities;
  final int askFood;
  final int askMusic;
  final int askArts;

  CategorySettingsEntity({
    this.askHistory = 1,
    this.askGeography = 1,
    this.askScience = 1,
    this.askSports = 1,
    this.askMedicine = 1,
    this.askLiterature = 1,
    this.askCelebrities = 1,
    this.askFood = 1,
    this.askMusic = 1,
    this.askArts = 1,
  });

  static CategorySettingsEntity fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return CategorySettingsEntity();
    } else {
      return CategorySettingsEntity(
        askHistory:
            map[SettingsDatabaseHelper.categorySettingsTableFieldHistory] ?? 1,
        askGeography:
            map[SettingsDatabaseHelper.categorySettingsTableFieldGeography] ??
                1,
        askScience:
            map[SettingsDatabaseHelper.categorySettingsTableFieldScience] ?? 1,
        askSports:
            map[SettingsDatabaseHelper.categorySettingsTableFieldSports] ?? 1,
        askMedicine:
            map[SettingsDatabaseHelper.categorySettingsTableFieldMedicine] ?? 1,
        askLiterature:
            map[SettingsDatabaseHelper.categorySettingsTableFieldLiterature] ??
                1,
        askCelebrities:
            map[SettingsDatabaseHelper.categorySettingsTableFieldCelebrities] ??
                1,
        askFood:
            map[SettingsDatabaseHelper.categorySettingsTableFieldFood] ?? 1,
        askMusic:
            map[SettingsDatabaseHelper.categorySettingsTableFieldMusic] ?? 1,
        askArts:
            map[SettingsDatabaseHelper.categorySettingsTableFieldArts] ?? 1,
      );
    }
  }

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

  CategorySettingsModel toModel() {
    return CategorySettingsModel(
      askHistory: intToBool(askHistory),
      askGeography: intToBool(askGeography),
      askScience: intToBool(askScience),
      askSports: intToBool(askSports),
      askMedicine: intToBool(askMedicine),
      askLiterature: intToBool(askLiterature),
      askCelebrities: intToBool(askCelebrities),
      askFood: intToBool(askFood),
      askMusic: intToBool(askMusic),
      askArts: intToBool(askArts),
    );
  }

  factory CategorySettingsEntity.fromModel(
      {required CategorySettingsModel model}) {
    return CategorySettingsEntity(
      askHistory: boolToInt(model.askHistory),
      askGeography: boolToInt(model.askGeography),
      askScience: boolToInt(model.askScience),
      askSports: boolToInt(model.askSports),
      askMedicine: boolToInt(model.askMedicine),
      askLiterature: boolToInt(model.askLiterature),
      askCelebrities: boolToInt(model.askCelebrities),
      askFood: boolToInt(model.askFood),
      askMusic: boolToInt(model.askMusic),
      askArts: boolToInt(model.askArts),
    );
  }

  bool intToBool(int boolAsInt) {
    if (boolAsInt == 1) {
      return true;
    } else {
      return false;
    }
  }

  static int boolToInt(bool intAsBool) {
    if (intAsBool == true) {
      return 1;
    } else {
      return 0;
    }
  }
}
