part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsStateLoaded extends SettingsState {
  final SettingsModel settingsModel;

  const SettingsStateLoaded({
    required this.settingsModel,
  });

  @override
  List<Object> get props => [
        settingsModel,
      ];
}

class SettingsStateError extends SettingsState {}

class SettingssStateLoading extends SettingsState {}
