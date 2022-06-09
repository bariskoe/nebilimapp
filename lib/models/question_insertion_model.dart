import 'package:equatable/equatable.dart';
import 'package:nebilimapp/database/database_helper.dart';

class QuestionInsertionModel extends Equatable {
  // static const String questionTableName = 'questionTable';
  // static const String questionId = 'questionId';
  // static const String questionDifficulty = 'difficulty';
  // static const String questionCategory = 'category';
  // static const String questionImageName = 'imageName';
  // static const String questionImageEnding = 'imageEnding';
  // static const String questionMusicName = 'musicName';
  // static const String questionMusicEnding = 'musicEnding';
  // static const String questionQuestionTextGerman = 'questionTextGerman';
  // static const String questionTableFieldAnswerTextGerman = 'answerTextGerman';
  // static const String questionTableFieldAdditionalInfoGerman =
  //     'additionalInfoGerman';
  // static const String questionTableFieldMainWordPositionGerman =
  //     'mainWordPositionGerman';
  // static const String questionTableFieldQuestionTextEnglish =
  //     'questionTextEnglish';
  // static const String questionTableFieldAnswerTextEnglish = 'answerTextEnglish';
  // static const String questionTableFieldAdditionalInfoEnglish =
  //     'additionalInfoEnglish';
  // static const String questionTableFieldMainWordPositionEnglish =
  //     'mainWordPositionEnglish';

  int questionId;
  int questionDifficulty;
  int questionCategory;
  String questionImageName;
  String questionImageEnding;
  String questionMusicName;
  //TODO: A respective extension is needed for musicEnding
  String questionMusicEnding;
  String questionTextGerman;
  String questionAnswerTextGerman;
  String questionAdditionalInfoGerman;
  int questionMainWordPositionGerman;
  String questionTextEnglish;
  String questionAnswerTextEnglish;
  String questionAdditionalInfoEnglish;
  int questionMainWordPositionEnglish;
  QuestionInsertionModel({
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
}

enum QuestionImageEnding { jpg }

extension QuestionImageEndingExtension on QuestionImageEnding {
  int serialize() {
    return QuestionImageEnding.values.indexOf(this);
  }

  static QuestionImageEnding deserialize(int serialzedQuestionImageEnding) {
    return QuestionImageEnding.values[serialzedQuestionImageEnding];
  }
}
