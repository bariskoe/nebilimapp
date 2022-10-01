import 'package:equatable/equatable.dart';

import 'question_insertion_model.dart';
import 'question_status_model.dart';

class QuestionModel with EquatableMixin {
  int questionId;
  int questionDifficulty;
  QuestionCategory questionCategory;
  String questionText;
  String questionAnswerText;
  String questionAdditionalInfo;
  int questionMainWordPosition;
  String? questionImageName;
  QuestionImageEnding? questionImageEnding;
  String? questionMusicName;
  String? questionMusicEnding;
  QuestionStatusModel? questionStatusModel;

  QuestionModel({
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
    this.questionStatusModel,
  });

  @override
  List<Object?> get props => [
        questionId,
        questionDifficulty,
        questionCategory,
        questionImageName,
        questionImageEnding,
        questionMusicName,
        questionMusicEnding,
        questionText,
        questionAnswerText,
        questionAdditionalInfo,
        questionMainWordPosition,
      ];

  bool get hasImage => (questionImageName != null) && (questionImageName != '');
  bool get hasAdditionalInfo => questionAdditionalInfo.isNotEmpty;
  int get getOneBasedDifficulty => questionDifficulty + 1;
}
