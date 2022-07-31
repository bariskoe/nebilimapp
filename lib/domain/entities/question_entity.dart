import 'package:intl/intl.dart';
import 'question_status_entity.dart';
import '../../models/question_insertion_model.dart';

import '../../database/database_helper.dart';
import '../../models/question_model.dart';



class QuestionEntity {
  final int questionId;
  final int questionDifficulty;
  final int questionCategory;
  final String questionText;
  final String questionAnswerText;
  final String questionAdditionalInfo;
  final int questionMainWordPosition;
  final String? questionImageName;
  final int? questionImageEnding;
  final String? questionMusicName;
  //TODO: A respective extension is needed for musicEnding
  final String? questionMusicEnding;
  final QuestionStatusEntity? questionStatusEntity;

  QuestionEntity({
    required this.questionId,
    required this.questionDifficulty,
    required this.questionCategory,
    required this.questionText,
    required this.questionAnswerText,
    required this.questionAdditionalInfo,
    required this.questionMainWordPosition,
    this.questionImageName,
    this.questionImageEnding,
    this.questionMusicName,
    this.questionMusicEnding,
    this.questionStatusEntity,
  });

//Todo: Passt das so?
  factory QuestionEntity.fromMap({
    required Map<String, dynamic> questionMap,
    Map<String, dynamic>? questionStatusMap,
  }) {
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

    QuestionStatusEntity? questionStatusEntity;
    if (questionStatusMap != null) {
      questionStatusEntity = QuestionStatusEntity.fromMap(questionStatusMap);
    }

    return QuestionEntity(
      questionId: questionMap[DatabaseHelper.questionTableFieldId],
      questionDifficulty:
          questionMap[DatabaseHelper.questionTableFieldDifficulty],
      questionCategory: questionMap[DatabaseHelper.questionTableFieldCategory],
      questionImageName:
          questionMap[DatabaseHelper.questionTableFieldImageName],
      questionImageEnding:
          questionMap[DatabaseHelper.questionTableFieldImageEnding]
                  .toString()
                  .isEmpty
              ? null
              : questionMap[DatabaseHelper.questionTableFieldImageEnding],
      questionMusicName:
          questionMap[DatabaseHelper.questionTableFieldMusicName],
      questionMusicEnding:
          questionMap[DatabaseHelper.questionTableFieldMusicEnding],
      questionText: questionMap[questionTextKey],
      questionAnswerText: questionMap[questionAnswerTextKey],
      questionAdditionalInfo: questionMap[questionAdditionalInfoKey],
      questionMainWordPosition: questionMap[questionMainWordPositionKey],
      questionStatusEntity: questionStatusEntity,
    );
  }

  QuestionModel toModel() {
    return QuestionModel(
      questionId: questionId,
      questionDifficulty: questionDifficulty,
      questionCategory: QuestionCategoryExtension.deserialize(questionCategory),
      questionImageName: questionImageName,
      questionImageEnding:
          QuestionImageEndingExtension.deserialize(questionImageEnding),
      questionMusicName: questionMusicName,
      questionMusicEnding: questionMusicEnding,
      questionText: questionText,
      questionAnswerText: questionAnswerText,
      questionAdditionalInfo: questionAdditionalInfo,
      questionMainWordPosition: questionMainWordPosition,
      questionStatusModel: questionStatusEntity?.toModel(),
    );
  }
}
