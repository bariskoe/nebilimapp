import 'package:equatable/equatable.dart';
import 'package:nebilimapp/domain/entities/question_status_entity.dart';

class QuestionStatusModel with EquatableMixin {
  int questionId;
  QuestionStatus questionStatus;
  DateTime? lastTimeAsked;
  QuestionStatusModel({
    required this.questionId,
    required this.questionStatus,
    required this.lastTimeAsked,
  });

  @override
  List<Object?> get props => [
        questionId,
        questionStatus,
        lastTimeAsked,
      ];
}
