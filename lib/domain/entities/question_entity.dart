import 'package:intl/intl.dart';
import '../../models/question_insertion_model.dart';

import '../../database/database_helper.dart';
import '../../models/question_model.dart';

//TODO: The Entity should only have raw Data, whereas the model should hold the respective ready-to-use data. Fix this entity!

class QuestionEntity {
  final int questionId;
  final int questionDifficulty;
  final int questionCategory;
  final String questionImageName;
  final QuestionImageEnding? questionImageEnding;
  final String questionMusicName;
  //TODO: A respective extension is needed for musicEnding
  final String questionMusicEnding;
  final String questionText;
  final String questionAnswerText;
  final String questionAdditionalInfo;
  final int questionMainWordPosition;

  QuestionEntity({
    required this.questionId,
    required this.questionDifficulty,
    required this.questionCategory,
    required this.questionImageName,
    required this.questionImageEnding,
    required this.questionMusicName,
    required this.questionMusicEnding,
    required this.questionText,
    required this.questionAnswerText,
    required this.questionAdditionalInfo,
    required this.questionMainWordPosition,
  });

//Todo: Passt das so?
  factory QuestionEntity.fromMap({required Map<String, dynamic> map}) {
    String currentLocale = Intl.getCurrentLocale();
    String questionTextKey = currentLocale.startsWith('de')
        ? DatabaseHelper.questionTableFieldQuestionTextGerman
        : DatabaseHelper.questionTableFieldQuestionTextEnglish;

    String questionAnswerTextKey = currentLocale.startsWith('de')
        ? DatabaseHelper.questionTableFieldAnswerTextGerman
        : DatabaseHelper.questionTableFieldAnswerTextEnglish;

    String questionAdditionalInfoKey = currentLocale.startsWith('de')
        ? DatabaseHelper.questionTableFieldAdditionalInfoGerman
        : DatabaseHelper.questionTableFieldAdditionalInfoEnglish;

    String questionMainWordPositionKey = currentLocale.startsWith('de')
        ? DatabaseHelper.questionTableFieldMainWordPositionGerman
        : DatabaseHelper.questionTableFieldMainWordPositionEnglish;

    return QuestionEntity(
        questionId: map[DatabaseHelper.questionTableFieldId],
        questionDifficulty: map[DatabaseHelper.questionTableFieldDifficulty],
        questionCategory: map[DatabaseHelper.questionTableFieldCategory],
        questionImageName: map[DatabaseHelper.questionTableFieldImageName],
        questionImageEnding:
            map[DatabaseHelper.questionTableFieldImageEnding].toString().isEmpty
                ? null
                : QuestionImageEndingExtension.deserialize(
                    map[DatabaseHelper.questionTableFieldImageEnding]),
        questionMusicName: map[DatabaseHelper.questionTableFieldMusicName],
        questionMusicEnding: map[DatabaseHelper.questionTableFieldMusicEnding],
        questionText: map[questionTextKey],
        questionAnswerText: map[questionAnswerTextKey],
        questionAdditionalInfo: map[questionAdditionalInfoKey],
        questionMainWordPosition: map[questionMainWordPositionKey]);
  }

  QuestionModel toModel() {
    return QuestionModel(
      questionId: questionId,
      questionDifficulty: questionDifficulty,
      questionCategory: questionCategory,
      questionImageName: questionImageName,
      questionImageEnding: questionImageEnding,
      questionMusicName: questionMusicName,
      questionMusicEnding: questionMusicEnding,
      questionText: questionText,
      questionAnswerText: questionAnswerText,
      questionAdditionalInfo: questionAdditionalInfo,
      questionMainWordPosition: questionMainWordPosition,
    );
  }
}
