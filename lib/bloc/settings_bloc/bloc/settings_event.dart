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
