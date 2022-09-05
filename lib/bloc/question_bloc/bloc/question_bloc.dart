import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/failures/failures.dart';
import '../../../domain/usecases/question_usecases.dart';
import '../../../models/question_model.dart';
import '../../../models/question_status_model.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionUsecases questionUsecases;

  int? currentQuestionId;

  QuestionBloc({
    required this.questionUsecases,
  }) : super(QuestionStateInitial()) {
    // on<>((event, emit) {
    // });

    on<QuestionEventTurnBackToInitialState>((event, emit) {
      emit(QuestionStateInitial());
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
        } else {
          emit(QuestionStateError());
        }
      }, (r) {
        emit(QuestionStateLoaded(questionModel: r));
        currentQuestionId = r.questionId;
        questionUsecases.insertTimeToLastTimeAskedTable(
            questionId: r.questionId);
        questionUsecases.insertQuestionIdToRecentlyAskedTable(
            questionId: r.questionId);
      });
    });

    // on<QuestionEventUpdateStatus>((event, emit) async {
    //   Either<Failure, int> updated =
    //       await questionUsecases.updateQuestionStatus(
    //     questionStatusModel: event.questionStatusModel,
    //   );
    // });

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
        emit(QuestionStateLoaded(questionModel: r));
        currentQuestionId = r.questionId;
      });
    });

    on<QuestionEventClearRecentlyAskedTable>((event, emit) async {
      emit(QuestionStateLoading());
      Either<Failure, int> failureOrDeletedRowsCount =
          await questionUsecases.clearRecentlyAskedQuestionsTable();
      failureOrDeletedRowsCount.fold((l) => emit(QuestionStateError()),
          (r) => add(QuestionEventGetFilterConfromQuestion()));
    });
  }
}
