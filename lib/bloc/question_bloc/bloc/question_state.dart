part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionStateLoaded extends QuestionState {
  final QuestionEntity questionModel;

  const QuestionStateLoaded({
    required this.questionModel,
  });

  @override
  List<Object> get props => [
        questionModel,
      ];
}

class QuestionStateError extends QuestionState {}
