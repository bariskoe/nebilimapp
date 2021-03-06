import '../../database/database_helper.dart';
import '../../models/question_status_model.dart';

class QuestionStatusEntity {
  int questionId;
  int questionStatusAsInt;
  //lastTimeAsked is an integer representing millisecondsSinceEpoch
  int? lastTimeAskedAsInt;

  QuestionStatusEntity({
    required this.questionId,
    required this.questionStatusAsInt,
    required this.lastTimeAskedAsInt,
  });

  factory QuestionStatusEntity.fromModel(
      {required QuestionStatusModel questionStatusModel}) {
    return QuestionStatusEntity(
        questionId: questionStatusModel.questionId,
        questionStatusAsInt: questionStatusModel.questionStatus.serialze(),
        lastTimeAskedAsInt:
            questionStatusModel.lastTimeAsked?.millisecondsSinceEpoch);
  }

  static QuestionStatusEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    } else {
      return QuestionStatusEntity(
        questionId: map[DatabaseHelper.questionStatusTableFieldQuestionID],
        questionStatusAsInt: map[DatabaseHelper.questionStatusTableFieldStatus],
        lastTimeAskedAsInt:
            map[DatabaseHelper.questionStatusTableFieldLastTimeAsked],
      );
    }
  }

  QuestionStatusModel toModel() {
    return QuestionStatusModel(
        questionId: questionId,
        questionStatus: QuestionStatusExtension.deserialize(
            serializedQuestionStatus: questionStatusAsInt),
        lastTimeAsked: lastTimeAskedAsInt != null
            ? DateTime.fromMillisecondsSinceEpoch(lastTimeAskedAsInt!)
            : null);
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.questionStatusTableFieldQuestionID: questionId,
      DatabaseHelper.questionStatusTableFieldStatus: questionStatusAsInt,
      DatabaseHelper.questionStatusTableFieldLastTimeAsked: lastTimeAskedAsInt,
    };
  }
}

enum QuestionStatus {
  unmarked,
  favorited,
  dontAskAgain,
}

extension QuestionStatusExtension on QuestionStatus {
  int serialze() {
    return QuestionStatus.values.indexOf(this);
  }

  static QuestionStatus deserialize({required int serializedQuestionStatus}) {
    return QuestionStatus.values[serializedQuestionStatus];
  }

  bool get isFavorited => this == QuestionStatus.favorited;
  bool get isUnmarked => this == QuestionStatus.unmarked;
  bool get isDontAskagain => this == QuestionStatus.dontAskAgain;
}
