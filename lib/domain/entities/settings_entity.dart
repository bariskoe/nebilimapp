import 'package:nebilimapp/domain/entities/category_settings_entity.dart';
import 'package:nebilimapp/models/settings_model.dart';

class SettingsEntity {
  final CategorySettingsEntity categorySettingsEntity;

  SettingsEntity({
    required this.categorySettingsEntity,
  });

  SettingsModel toModel() {
    return SettingsModel(
        categorySettingsModel: categorySettingsEntity.toModel());
  }

  factory SettingsEntity.fromModel(SettingsModel model) {
    return SettingsEntity(
      categorySettingsEntity:
          CategorySettingsEntity.fromModel(model: model.categorySettingsModel),
    );
  }
}
