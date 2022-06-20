part of 'question_bloc.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object> get props => [];
}

class QuestionEventGetRandomQuestion extends QuestionEvent {}

class QuestionEventUpdateStatus extends QuestionEvent {
  final QuestionStatusModel questionStatusModel;

  const QuestionEventUpdateStatus({
    required this.questionStatusModel,
  });

  @override
  List<Object> get props => [
        questionStatusModel,
      ];
}
