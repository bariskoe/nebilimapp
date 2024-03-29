// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class QuestionEventShowAnswer extends QuestionEvent {
  final bool? afterEndOfThinkingTime;
  final bool? afterPressingShowAnswer;
  const QuestionEventShowAnswer({
    this.afterEndOfThinkingTime = false,
    this.afterPressingShowAnswer = false,
  });

  @override
  List<Object> get props => [afterEndOfThinkingTime!, afterPressingShowAnswer!];
}

class QuestionEventSpeakHasFinished extends QuestionEvent {
  final bool wasQuestion;
  final bool wasAdditionalInfo;
  final bool wasAnswer;

  const QuestionEventSpeakHasFinished({
    required this.wasQuestion,
    required this.wasAdditionalInfo,
    required this.wasAnswer,
  });

  @override
  List<Object> get props => [
        wasQuestion,
        wasAdditionalInfo,
        wasAnswer,
      ];
}

class QuestionEventThinkingTimeAnimationHasFinished extends QuestionEvent {}

class QuestionEventUpdateSettingsState extends QuestionEvent {
  final SettingsStateLoaded settingsStateLoaded;

  const QuestionEventUpdateSettingsState({
    required this.settingsStateLoaded,
  });

  @override
  List<Object> get props => [
        settingsStateLoaded,
      ];
}
