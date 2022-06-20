import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:nebilimapp/models/question_status_model.dart';
import '../../../domain/entities/question_entity.dart';
import '../../../domain/failures/failures.dart';
import '../../../domain/usecases/question_usecases.dart';
import '../../../models/question_model.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionUsecases questionUsecases;

  QuestionBloc({
    required this.questionUsecases,
  }) : super(QuestionInitial()) {
    // on<>((event, emit) {

    // });

    on<QuestionEventGetRandomQuestion>((event, emit) async {
      Logger().d('QuestionEventGetRandomQuestio eingelangt');
      Either<Failure, QuestionEntity> failureOrQuestionModel =
          await questionUsecases.getRandomQuestion();

      failureOrQuestionModel.fold((l) {
        emit(QuestionStateError());
      }, (r) => emit(QuestionStateLoaded(questionModel: r.toModel())));
    });

    on<QuestionEventUpdateStatus>((event, emit) async {
      Either<Failure, int> updated =
          await questionUsecases.updateQuestionStatus(
        questionStatusModel: event.questionStatusModel,
      );
    });
  }
}
