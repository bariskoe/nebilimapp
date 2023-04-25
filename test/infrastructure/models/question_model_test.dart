import 'package:flutter_test/flutter_test.dart';
import 'package:nebilimapp/models/question_insertion_model.dart';
import 'package:nebilimapp/models/question_model.dart';

void main() {
  final tQuestionModel = QuestionModel(
    questionAdditionalInfo: 'Seit 1990',
    questionAnswerText: 'Berlin',
    questionCategory: QuestionCategory.geography,
    questionDifficulty: 1,
    questionId: 21,
    questionMainWordPosition: 0,
    questionText: 'Was ist die Hauptstadt von Deutschland',
  );
  final hasimage = tQuestionModel.hasImage;
  final hasAdditionalInfo = tQuestionModel.hasAdditionalInfo;
  final int oneBasedDifficulty = tQuestionModel.getOneBasedDifficulty;

  group('Test hasimage related things', () {
    test('Hasimage should be false for t_questionModel', () {
      expect(hasimage, false);
    });

    test('Hasimage should be a bool', () {
      expect(hasimage, isA<bool>());
    });
  });

  group('Test hasAdditionalInfo related things', () {
    test('HasadditionalInfo should be true', () {
      expect(hasAdditionalInfo, true);
    });

    test('HasadditionalInfo should be a bool', () {
      expect(hasAdditionalInfo, isA<bool>());
    });
  });

  group('Test difficulty related thing', () {
    test('One based difficulty should be questionDifficulty + 1', () {
      expect(oneBasedDifficulty, tQuestionModel.questionDifficulty + 1);
    });
  });
}
