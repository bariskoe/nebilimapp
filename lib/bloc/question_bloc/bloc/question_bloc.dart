import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/failures/failures.dart';
import '../../../domain/usecases/question_usecases.dart';
import '../../../models/question_model.dart';
import '../../../models/question_status_model.dart';
import '../../animation_bloc/bloc/animation_bloc.dart';
import '../../settings_bloc/bloc/settings_bloc.dart';
import '../../text_to_speech_bloc/bloc/text_to_speech_bloc.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionUsecases questionUsecases;
  AnimationBloc animationBloc;
  TextToSpeechBloc textToSpeechBloc;
  final SettingsBloc _settingsBloc;
  late StreamSubscription subscriptionToSettingsBloc;
  //! Strange: If I declare this as SettingsState and say if state is
  //! SettingsStateLoaded {currentSettingsState = state}, I can not
  //! do currentSettingsState.settingsModel
  SettingsStateLoaded? currentSettingsStateLoaded;

  int? currentQuestionId;
  QuestionStateLoaded? currentQuestionStateLoaded;

  QuestionBloc({
    required this.questionUsecases,
    required this.animationBloc,
    required this.textToSpeechBloc,
    required SettingsBloc settingsBloc,
  })  : _settingsBloc = settingsBloc,
        super(QuestionStateInitial()) {
    // on<>((event, emit)async {
    // });

    subscriptionToSettingsBloc =
        _settingsBloc.stream.listen((SettingsState state) {
      if (state is SettingsStateLoaded) {
        add(QuestionEventUpdateSettingsState(settingsStateLoaded: state));
      }
    });
    on<QuestionEventTurnBackToInitialState>((event, emit) {
      emit(QuestionStateInitial());
    });

    on<QuestionEventUpdateSettingsState>((event, emit) async {
      currentSettingsStateLoaded = event.settingsStateLoaded;
    });

    on<QuestionEventGetRandomQuestion>((event, emit) async {
      Either<Failure, QuestionModel> failureOrQuestionModel =
          await questionUsecases.getRandomQuestion();

      failureOrQuestionModel.fold((l) {
        emit(QuestionStateError());
      }, (r) {
        emit(QuestionStateLoaded(questionModel: r));
        currentQuestionId = r.questionId;
        questionUsecases.insertTimeToLastTimeAskedTable(
            questionId: r.questionId);
        questionUsecases.insertQuestionIdToRecentlyAskedTable(
            questionId: r.questionId);
      });
    });

    on<QuestionEventGetFilterConfromQuestion>((event, emit) async {
      Either<Failure, QuestionModel> failureOrQuestionModel =
          await questionUsecases.getFilterConformQuestion();

      failureOrQuestionModel.fold((l) {
        if (l is AllfilterConformQuestionsRecentlyAskedFailure) {
          emit(QuestionStateAllfilterConformQuestionsRecentlyAsked());
        } else if (l is NotYetCoveredCaseExceptionFailure) {
          emit(QuestionStateNotYetCoveredFailure());
        } else if (l is NoFilterConformQuestionsExistFailure) {
          emit(QuestionStateNoFilterConformQuestionsExist());
        } else {
          emit(QuestionStateError());
        }
      }, (r) {
        emit(QuestionStateLoaded(questionModel: r));
        currentQuestionStateLoaded = QuestionStateLoaded(questionModel: r);
        currentQuestionId = r.questionId;
        questionUsecases.insertTimeToLastTimeAskedTable(
            questionId: r.questionId);
        questionUsecases.insertQuestionIdToRecentlyAskedTable(
            questionId: r.questionId);

        if (currentSettingsStateLoaded?.settingsModel.textToSpeechOn ?? false) {
          textToSpeechBloc.add(TextToSpeechEventSpeak(
            text: r.questionText,
            ttsOn: currentSettingsStateLoaded?.settingsModel.textToSpeechOn,
            isQuestion: true,
            isAdditionalInfo: false,
            isAnswer: false,
          ));
        }
      });
    });

    on<QuestionEventToggleFavoriteStatus>((event, emit) async {
      if (currentQuestionId != null) {
        Either<Failure, int> failureOrToggled = await questionUsecases
            .toggleFavoriteStatus(questionId: event.questionId);
        failureOrToggled.fold((l) => emit(QuestionStateError()), (r) {
          add(QuestionEventGetQuestionById(questionId: event.questionId));
        });
      }
    });

    on<QuestionEventToggleDontShowAgain>((event, emit) async {
      Either<Failure, int> failureOrMarked =
          await questionUsecases.toggleDontAskAgain(
        questionId: event.questionId,
      );
      failureOrMarked.fold(
        (l) => emit(
          QuestionStateError(),
        ),
        (r) => add(QuestionEventGetQuestionById(questionId: event.questionId)),
      );
    });

    on<QuestionEventGetQuestionById>((event, emit) async {
      emit(QuestionStateLoading());
      Either<Failure, QuestionModel> failureOrQuestionModel =
          await questionUsecases.getQuestionById(questionId: event.questionId);

      failureOrQuestionModel.fold((l) {
        emit(QuestionStateError());
      }, (r) {
        if (currentQuestionStateLoaded?.questionModel.questionId ==
            r.questionId) {
          emit(QuestionStateLoaded(questionModel: r).copyWith(
              showAnswer: currentQuestionStateLoaded?.showAnswer ?? false));
        } else {
          emit(QuestionStateLoaded(questionModel: r));
        }

        currentQuestionId = r.questionId;
        currentQuestionStateLoaded = QuestionStateLoaded(questionModel: r);
      });
    });

    on<QuestionEventClearRecentlyAskedTable>((event, emit) async {
      emit(QuestionStateLoading());
      Either<Failure, int> failureOrDeletedRowsCount =
          await questionUsecases.clearRecentlyAskedQuestionsTable();
      failureOrDeletedRowsCount.fold((l) => emit(QuestionStateError()),
          (r) => add(QuestionEventGetFilterConfromQuestion()));
    });

    on<QuestionEventShowAnswer>((event, emit) async {
      if (event.afterPressingShowAnswer ?? false) {
        animationBloc.add(AnimationEventResetAnimation());
        textToSpeechBloc.add(TextToSpeechEventStopSpeaking());
      }

      if (event.afterEndOfThinkingTime ?? false) {}
      if (currentSettingsStateLoaded?.settingsModel.textToSpeechOn ?? false) {
        textToSpeechBloc.add(TextToSpeechEventSpeak(
          text: currentQuestionStateLoaded?.questionModel.questionAnswerText ??
              '',
          ttsOn: currentSettingsStateLoaded?.settingsModel.textToSpeechOn,
          isAdditionalInfo: false,
          isAnswer: true,
          isQuestion: false,
        ));
      }
      if (currentQuestionStateLoaded != null) {
        currentQuestionStateLoaded =
            currentQuestionStateLoaded!.copyWith(showAnswer: true);
        emit(currentQuestionStateLoaded!.copyWith(showAnswer: true));
      }
    });

    on<QuestionEventSpeakHasFinished>((event, emit) async {
      if (currentSettingsStateLoaded != null &&
          currentSettingsStateLoaded!.settingsModel.thinkingTimeModel.active &&
          event.wasQuestion) {
        //! Is the totalanimationDuration needed in this event? The ThinkingTimeAnimation gets its duration
        //! from the settings anyway

        animationBloc.add(const AnimationEventStartThinkingTimeAnimation(
            totalAnimationDuration: 0));
      }
      if (event.wasAnswer) {
        if (currentSettingsStateLoaded != null &&
            currentQuestionStateLoaded!.questionModel.hasAdditionalInfo ==
                false &&
            currentSettingsStateLoaded!.settingsModel.chainQuestionsOn) {
          Future.delayed(
              Duration(
                  seconds: currentSettingsStateLoaded!
                      .settingsModel.restingTime), () async {
            animationBloc.add(AnimationEventResetAnimation());

            add(QuestionEventGetFilterConfromQuestion());
          });
        } else {
          currentQuestionStateLoaded?.questionModel.hasAdditionalInfo ?? false
              ? textToSpeechBloc.add(TextToSpeechEventSpeak(
                  text: currentQuestionStateLoaded!
                      .questionModel.questionAdditionalInfo,
                  ttsOn:
                      currentSettingsStateLoaded?.settingsModel.textToSpeechOn,
                  isAdditionalInfo: true,
                  isAnswer: false,
                  isQuestion: false,
                ))
              : null;
        }
      } else if (event.wasAdditionalInfo) {
        if (currentSettingsStateLoaded != null &&
            currentSettingsStateLoaded!.settingsModel.chainQuestionsOn) {
          Future.delayed(
              Duration(
                  seconds: currentSettingsStateLoaded!
                      .settingsModel.restingTime), () async {
            animationBloc.add(AnimationEventResetAnimation());
            add(QuestionEventGetFilterConfromQuestion());
          });
        }
      }
    });

    on<QuestionEventThinkingTimeAnimationHasFinished>((event, emit) async {
      add(const QuestionEventShowAnswer(afterEndOfThinkingTime: true));
    });
  }
}
