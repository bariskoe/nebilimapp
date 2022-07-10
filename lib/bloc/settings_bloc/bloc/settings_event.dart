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

class SettingsEventToggleAskDifficulty extends SettingsEvent {
  final int difficultyAsInt;

  const SettingsEventToggleAskDifficulty({
    required this.difficultyAsInt,
  });
  @override
  List<Object> get props => [
        difficultyAsInt,
      ];
}

class SettingsEventToggleAskMarkedAs extends SettingsEvent {
  final String statusName;

  const SettingsEventToggleAskMarkedAs({
    required this.statusName,
  });
  @override
  List<Object> get props => [
        statusName,
      ];
}
