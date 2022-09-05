part of 'question_bloc.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object> get props => [];
}

class QuestionEventTurnBackToInitialState extends QuestionEvent {}

class QuestionEventGetRandomQuestion extends QuestionEvent {}

class QuestionEventGetFilterConfromQuestion extends QuestionEvent {}

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

class QuestionEventToggleFavoriteStatus extends QuestionEvent {
  final int questionId;
  const QuestionEventToggleFavoriteStatus({required this.questionId});

  @override
  List<Object> get props => [
        questionId,
      ];
}

class QuestionEventGetQuestionById extends QuestionEvent {
  final int questionId;
  const QuestionEventGetQuestionById({required this.questionId});
  @override
  List<Object> get props => [
        questionId,
      ];
}

class QuestionEventToggleDontShowAgain extends QuestionEvent {
  final int questionId;
  const QuestionEventToggleDontShowAgain({
    required this.questionId,
  });

  @override
  List<Object> get props => [
        questionId,
      ];
}

class QuestionEventClearRecentlyAskedTable extends QuestionEvent {}
