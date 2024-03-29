import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../locale/locale.dart';
import '../../models/question_status_model.dart';

class QuestionStatusEntity {
  int questionId;
  int questionStatusAsInt;

  QuestionStatusEntity({
    required this.questionId,
    required this.questionStatusAsInt,
  });

  factory QuestionStatusEntity.fromModel(
      {required QuestionStatusModel questionStatusModel}) {
    return QuestionStatusEntity(
      questionId: questionStatusModel.questionId,
      questionStatusAsInt: questionStatusModel.questionStatus.serialze(),
    );
  }

  static QuestionStatusEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    } else {
      return QuestionStatusEntity(
        questionId: map[DatabaseHelper.questionStatusTableFieldQuestionID],
        questionStatusAsInt: map[DatabaseHelper.questionStatusTableFieldStatus],
      );
    }
  }

  QuestionStatusModel toModel() {
    return QuestionStatusModel(
      questionId: questionId,
      questionStatus: QuestionStatusExtension.deserialize(
          serializedQuestionStatus: questionStatusAsInt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.questionStatusTableFieldQuestionID: questionId,
      DatabaseHelper.questionStatusTableFieldStatus: questionStatusAsInt,
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

  static QuestionStatus fromName({required String name}) {
    return QuestionStatus.values.firstWhere((element) => element.name == name);
  }

  IconData getIcon() {
    switch (this) {
      case QuestionStatus.unmarked:
        return Icons.question_mark;
      case QuestionStatus.favorited:
        return Icons.favorite;

      case QuestionStatus.dontAskAgain:
        return Icons.delete;
    }
  }

  String getName(BuildContext context) {
    switch (this) {
      case QuestionStatus.unmarked:
        return S.of(context).questionStatusUnmarked;
      case QuestionStatus.favorited:
        return S.of(context).questionStatusFavorite;

      case QuestionStatus.dontAskAgain:
        return S.of(context).questionStatusDontAskAgain;
    }
  }

  bool get isFavorited => this == QuestionStatus.favorited;

  bool get isDontAskagain => this == QuestionStatus.dontAskAgain;
}
