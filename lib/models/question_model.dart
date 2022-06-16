import 'package:equatable/equatable.dart';
import 'package:nebilimapp/domain/entities/question_entity.dart';
import 'package:nebilimapp/models/question_insertion_model.dart';

class QuestionModel extends QuestionEntity with EquatableMixin {
  QuestionModel({
    required int questionId,
    required int questionDifficulty,
    required int questionCategory,
    required String questionImageName,
    required QuestionImageEnding? questionImageEnding,
    required String questionMusicName,
    required String questionMusicEnding,
    required String questionText,
    required String questionAnswerText,
    required String questionAdditionalInfo,
    required int questionMainWordPosition,
  }) : super(
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
}
