import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class QuestionInsertionModel extends Equatable {
  final int questionId;
  final int questionDifficulty;
  final int questionCategory;
  final String questionImageName;
  final String questionImageEnding;
  final String questionMusicName;
  //TODO: A respective extension is needed for musicEnding
  final String questionMusicEnding;
  final String questionTextGerman;
  final String questionAnswerTextGerman;
  final String questionAdditionalInfoGerman;
  final int questionMainWordPositionGerman;
  final String questionTextEnglish;
  final String questionAnswerTextEnglish;
  final String questionAdditionalInfoEnglish;
  final int questionMainWordPositionEnglish;
  const QuestionInsertionModel({
    required this.questionId,
    required this.questionDifficulty,
    required this.questionCategory,
    required this.questionImageName,
    required this.questionImageEnding,
    required this.questionMusicName,
    required this.questionMusicEnding,
    required this.questionTextGerman,
    required this.questionAnswerTextGerman,
    required this.questionAdditionalInfoGerman,
    required this.questionMainWordPositionGerman,
    required this.questionTextEnglish,
    required this.questionAnswerTextEnglish,
    required this.questionAdditionalInfoEnglish,
    required this.questionMainWordPositionEnglish,
  });

  factory QuestionInsertionModel.fromList(List<dynamic> questionAsList) {
    /// One row in the csv file represents one question. A row is represented
    /// by a list. Example:
    /// [1, 3, 1, , , , , In welchem Jahr fiel die Berliner Mauer?, 1989, ,
    /// 0, In which year did the Berlin wall fall?, 1989, , 0, , ]
    return QuestionInsertionModel(
      questionId: questionAsList[0],
      questionDifficulty: questionAsList[1],
      questionCategory: questionAsList[2],
      questionImageName: questionAsList[3].toString(),
      questionImageEnding: questionAsList[4].toString(),
      questionMusicName: questionAsList[5].toString(),
      questionMusicEnding: questionAsList[6].toString(),
      questionTextGerman: questionAsList[7].toString(),
      questionAnswerTextGerman: questionAsList[8].toString(),
      questionAdditionalInfoGerman: questionAsList[9].toString(),
      questionMainWordPositionGerman: questionAsList[10],
      questionTextEnglish: questionAsList[11].toString(),
      questionAnswerTextEnglish: questionAsList[12].toString(),
      questionAdditionalInfoEnglish: questionAsList[13].toString(),
      questionMainWordPositionEnglish: questionAsList[14],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.questionTableFieldId: questionId,
      DatabaseHelper.questionTableFieldDifficulty: questionDifficulty,
      DatabaseHelper.questionTableFieldCategory: questionCategory,
      DatabaseHelper.questionTableFieldImageName: questionImageName,
      DatabaseHelper.questionTableFieldImageEnding: questionImageEnding,
      DatabaseHelper.questionTableFieldMusicName: questionMusicName,
      DatabaseHelper.questionTableFieldMusicEnding: questionMusicEnding,
      DatabaseHelper.questionTableFieldQuestionTextGerman: questionTextGerman,
      DatabaseHelper.questionTableFieldAnswerTextGerman:
          questionAnswerTextGerman,
      DatabaseHelper.questionTableFieldAdditionalInfoGerman:
          questionAdditionalInfoGerman,
      DatabaseHelper.questionTableFieldMainWordPositionGerman:
          questionMainWordPositionGerman,
      DatabaseHelper.questionTableFieldQuestionTextEnglish: questionTextEnglish,
      DatabaseHelper.questionTableFieldAnswerTextEnglish:
          questionAnswerTextEnglish,
      DatabaseHelper.questionTableFieldAdditionalInfoEnglish:
          questionAdditionalInfoEnglish,
      DatabaseHelper.questionTableFieldMainWordPositionEnglish:
          questionMainWordPositionEnglish,
    };
  }

  @override
  List<Object?> get props => [
        questionId,
        questionDifficulty,
        questionCategory,
        questionImageName,
        questionImageEnding,
        questionMusicName,
        questionMusicEnding,
        questionTextGerman,
        questionAnswerTextGerman,
        questionAdditionalInfoGerman,
        questionMainWordPositionGerman,
        questionTextEnglish,
        questionAnswerTextEnglish,
        questionAdditionalInfoEnglish,
        questionMainWordPositionEnglish,
      ];
}

enum QuestionCategory {
  history,
  geography,
  science,
  sports,
  medicine,
  literature,
  celebrities,
  food,
  music,
  arts,
}

extension QuestionCategoryExtension on QuestionCategory {
  int serialze() {
    const categories = QuestionCategory.values;
    return categories.indexOf(this);
  }

  static QuestionCategory deserialize(int serializedCategory) {
    const categories = QuestionCategory.values;
    return categories[serializedCategory];
  }

  String getName() {
    return name;
  }

  IconData getCategoryIcon() {
    switch (this) {
      case QuestionCategory.history:
        return Icons.hourglass_empty;

      case QuestionCategory.geography:
        return Icons.public;

      case QuestionCategory.science:
        return Icons.science;

      case QuestionCategory.sports:
        return Icons.sports_tennis_outlined;

      case QuestionCategory.medicine:
        return Icons.medical_services_outlined;

      case QuestionCategory.literature:
        return Icons.menu_book;

      case QuestionCategory.celebrities:
        return Icons.camera_alt_outlined;

      case QuestionCategory.food:
        return Icons.fastfood;

      case QuestionCategory.music:
        return Icons.queue_music_rounded;

      case QuestionCategory.arts:
        return Icons.palette;
    }
  }
}

enum QuestionImageEnding { jpg }

extension QuestionImageEndingExtension on QuestionImageEnding {
  int serialize() {
    return QuestionImageEnding.values.indexOf(this);
  }

  String getname() {
    switch (this) {
      case QuestionImageEnding.jpg:
        return 'jpg';
    }
  }

  static QuestionImageEnding? deserialize(int? serialzedQuestionImageEnding) {
    if (serialzedQuestionImageEnding == null) {
      return null;
    } else {
      return QuestionImageEnding.values[serialzedQuestionImageEnding];
    }
  }
}
