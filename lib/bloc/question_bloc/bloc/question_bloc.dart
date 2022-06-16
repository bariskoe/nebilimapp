import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nebilimapp/domain/entities/question_entity.dart';
import 'package:nebilimapp/domain/failures/failures.dart';
import 'package:nebilimapp/domain/usecases/question_usecases.dart';
import 'package:nebilimapp/models/question_model.dart';

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
      Either<Failure, QuestionEntity> failureOrQuestionModel =
          await questionUsecases.getRandomQuestion();

      failureOrQuestionModel.fold((l) {
        print('emitting QuestionStateError');
        emit(QuestionStateError());
      }, (r) => emit(QuestionStateLoaded(questionModel: r)));
    });
  }
}
