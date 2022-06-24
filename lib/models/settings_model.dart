import 'package:equatable/equatable.dart';
import 'package:nebilimapp/models/category_settings_model.dart';

class SettingsModel extends Equatable {
  final CategorySettingsModel categorySettingsModel;

  const SettingsModel({
    required this.categorySettingsModel,
  });

  @override
  List<Object?> get props => [
        categorySettingsModel,
      ];
}
