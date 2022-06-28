part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsEventGetAllSettings extends SettingsEvent {
  const SettingsEventGetAllSettings();

  @override
  List<Object> get props => [];
}

class SettingsEventToggleAskCategory extends SettingsEvent {
  final int categoryAsInt;

  const SettingsEventToggleAskCategory({
    required this.categoryAsInt,
  });
  @override
  List<Object> get props => [
        categoryAsInt,
      ];
}
