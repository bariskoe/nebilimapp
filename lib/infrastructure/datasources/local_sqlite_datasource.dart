import 'package:nebilimapp/domain/entities/question_entity.dart';

abstract class LocalSqliteDataSource {
  /// Checks if the asset assets/Aktive Fragen Flutter - Sheet2.csv has
  /// the same length as in the last check. If not, this means the csv file
  /// has been updated. All questions in the database will be deleted and the
  /// database will be filled again with the new data
  Future<bool> updateQuestionDatabaseIfNeccessary();

  /// Choses a random question from the database and returns a [QuestionEntity].
  Future<QuestionEntity> getRandomQuestion();
}
