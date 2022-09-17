import '../../database/settings_database_helper.dart';
import '../../models/category_settings_model.dart';
import '../../models/question_insertion_model.dart';
import '../../utils/utils.dart';

class CategorySettingsEntity {
  final int categoryAsInt;
  final int askAsInt;

  CategorySettingsEntity({
    required this.categoryAsInt,
    this.askAsInt = 1,
  });

  static CategorySettingsEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    } else {
      return CategorySettingsEntity(
        categoryAsInt:
            map[SettingsDatabaseHelper.categorySettingsTableFieldCategoryAsInt],
        askAsInt:
            map[SettingsDatabaseHelper.categorySettingsTableFieldAsk] ?? 1,
      );
    }
  }

  static CategorySettingsEntity fromEnumValue(
      {required QuestionCategory questionCategoryEnumValue}) {
    return CategorySettingsEntity(
        categoryAsInt: questionCategoryEnumValue.serialze(), askAsInt: 1);
  }

  Map<String, dynamic> toMap() {
    return {
      SettingsDatabaseHelper.categorySettingsTableFieldCategoryAsInt:
          categoryAsInt,
      SettingsDatabaseHelper.categorySettingsTableFieldAsk: askAsInt,
    };
  }

  CategorySettingsModel toModel() {
    return CategorySettingsModel(
      questionCategory: QuestionCategoryExtension.deserialize(categoryAsInt),
      ask: intToBool(askAsInt),
    );
  }

  factory CategorySettingsEntity.fromModel(
      {required CategorySettingsModel model}) {
    return CategorySettingsEntity(
      categoryAsInt: model.questionCategory.serialze(),
      askAsInt: boolToInt(model.ask),
    );
  }
}
