import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/failures/failures.dart';
import '../../../domain/usecases/settings_usecases.dart';
import '../../../models/settings_model.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsUsecases settingsUsecases;

  SettingsBloc({
    required this.settingsUsecases,
  }) : super(SettingsInitial()) {
    // on<SettingsEvent>((event, emit) {
    // });

    on<SettingsEventGetAllSettings>((event, emit) async {
      Either<Failure, SettingsModel> failureOrSettingsModel =
          await settingsUsecases.getAllSettings();

      failureOrSettingsModel.fold((l) => emit(SettingsStateError()), (r) {
        emit(SettingsStateLoaded(settingsModel: r));
      });
    });

    on<SettingsEventToggleAskCategory>((event, emit) async {
      Either<Failure, int> failureOrToggled = await settingsUsecases
          .toggleAskCategory(categoryAsInt: event.categoryAsInt);

      failureOrToggled.fold((l) => emit(SettingsStateError()), (r) {
        add(const SettingsEventGetAllSettings());
      });
    });
  }
}