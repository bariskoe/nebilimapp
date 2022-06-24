import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nebilimapp/domain/failures/failures.dart';
import 'package:nebilimapp/domain/usecases/settings_usecases.dart';
import 'package:nebilimapp/models/settings_model.dart';

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
  }
}
