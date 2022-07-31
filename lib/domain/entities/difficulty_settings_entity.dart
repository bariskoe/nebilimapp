import '../../database/settings_database_helper.dart';
import '../../models/difficulty_settings_model.dart';

class DifficultySettingsEntity {
  final int difficultyAsInt;
  int ask;

  DifficultySettingsEntity({
    required this.difficultyAsInt,
    required this.ask,
  });

  DifficultySettingsModel toModel() {
    return DifficultySettingsModel(
        difficultyEnum: DifficultyExtension.deserialize(difficultyAsInt),
        ask: ask == 0 ? false : true);
  }

  static DifficultySettingsEntity fromModel(DifficultySettingsModel model) {
    return DifficultySettingsEntity(
        difficultyAsInt: model.difficultyEnum.getDifficultyAsInt,
        ask: model.ask == true ? 1 : 0);
  }

  Map<String, dynamic> toMap() {
    return {
      SettingsDatabaseHelper.difficultySettingsTableFieldDifficultyAsInt:
          difficultyAsInt,
      SettingsDatabaseHelper.difficultySettingsTableFieldAsk: ask,
    };
  }

  static DifficultySettingsEntity fromMap(Map<String, dynamic> map) {
    return DifficultySettingsEntity(
        difficultyAsInt: map[
            SettingsDatabaseHelper.difficultySettingsTableFieldDifficultyAsInt],
        ask: map[SettingsDatabaseHelper.difficultySettingsTableFieldAsk]);
  }

  static DifficultySettingsEntity fromEnumValue(
      {required DifficultyEnum difficultyEnum}) {
    return DifficultySettingsEntity(
        difficultyAsInt: difficultyEnum.getDifficultyAsInt, ask: 1);
  }
}
