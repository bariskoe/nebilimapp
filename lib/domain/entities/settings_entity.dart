import 'category_settings_entity.dart';

class SettingsEntity {
  final CategorySettingsEntity categorySettingsEntity;

  SettingsEntity({
    required this.categorySettingsEntity,
  });

  // SettingsModel toModel() {
  //   return SettingsModel(
  //       categorySettingsModelList: categorySettingsEntity.toModel());
  // }

  // factory SettingsEntity.fromModel(SettingsModel model) {
  //   return SettingsEntity(
  //     categorySettingsEntity:
  //         CategorySettingsEntity.fromModel(model: model.categorySettingsModel),
  //   );
  // }
}
