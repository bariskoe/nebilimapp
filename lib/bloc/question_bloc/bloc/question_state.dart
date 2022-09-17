// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionStateInitial extends QuestionState {}

class QuestionStateLoaded extends QuestionState {
  final QuestionModel questionModel;
  final bool showAnswer;

  const QuestionStateLoaded({
    required this.questionModel,
    this.showAnswer = false,
  });

  @override
  List<Object> get props => [questionModel, showAnswer];

  QuestionStateLoaded copyWith({
    QuestionModel? questionModel,
    bool? showAnswer,
  }) {
    return QuestionStateLoaded(
        questionModel: questionModel ?? this.questionModel,
        showAnswer: showAnswer ?? false);
  }
}

class QuestionStateError extends QuestionState {}

class QuestionStateLoading extends QuestionState {}

class QuestionStateAllfilterConformQuestionsRecentlyAsked
    extends QuestionState {}

class QuestionStateNotYetCoveredFailure extends QuestionState {}

class QuestionStateNoFilterConformQuestionsExist extends QuestionState {}
