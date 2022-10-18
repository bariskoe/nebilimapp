import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../dependency_injection.dart';
import '../../../domain/failures/failures.dart';
import '../../../models/settings_model.dart';
import '../../question_bloc/bloc/question_bloc.dart';
import '../../settings_bloc/bloc/settings_bloc.dart';

part 'animation_event.dart';
part 'animation_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  final SettingsBloc settingsBloc;

  AnimationBloc({
    required this.settingsBloc,
  }) : super(const AnimationInitial(totalAnimationDuration: 0)) {
    // on<AnimationEvent>((event, emit) async{

    // });

    on<AnimationEventStartThinkingTimeAnimation>((event, emit) async {
      Either<Failure, SettingsModel> failureOrSettingsModel =
          await settingsBloc.settingsUsecases.getAllSettings();
      failureOrSettingsModel.fold(
          (l) => emit(AnimationStateError()),
          (r) => emit(
                AnimationStateThinkingTimeAnimationRunning(
                  totalAnimationDuration: r.thinkingTimeModel.seconds,
                ),
              ));
    });

    on<AnimationEventResetAnimation>((event, emit) async {
      emit(const AnimationInitial(totalAnimationDuration: 0));
    });

    on<AnimationEventThinkingTimeAnimationHasFinished>((event, emit) async {
      getIt<QuestionBloc>()
          .add(QuestionEventThinkingTimeAnimationHasFinished());
    });
  }
}
