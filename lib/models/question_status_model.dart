import 'package:equatable/equatable.dart';

import '../domain/entities/question_status_entity.dart';

class QuestionStatusModel with EquatableMixin {
  int questionId;
  QuestionStatus questionStatus;

  QuestionStatusModel({
    required this.questionId,
    required this.questionStatus,
  });

  @override
  List<Object?> get props => [
        questionId,
        questionStatus,
      ];
}
