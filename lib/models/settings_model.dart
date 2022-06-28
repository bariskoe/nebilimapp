import 'package:equatable/equatable.dart';
import 'package:nebilimapp/models/category_settings_model.dart';

class SettingsModel extends Equatable {
  final List<CategorySettingsModel> categorySettingsModelList;

  const SettingsModel({
    required this.categorySettingsModelList,
  });

  @override
  List<Object?> get props => [
        categorySettingsModelList,
      ];
}
