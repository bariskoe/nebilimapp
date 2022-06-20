import 'package:nebilimapp/models/question_status_model.dart';

import '../../domain/entities/question_entity.dart';

abstract class LocalSqliteDataSource {
  /// Checks if the asset assets/Aktive Fragen Flutter - Sheet2.csv has
  /// the same length as in the last check. If not, this means the csv file
  /// has been updated. All questions in the database will be deleted and the
  /// database will be filled again with the new data
  Future<bool> updateQuestionDatabaseIfNeccessary();

  /// Choses a random question from the database and returns a [QuestionEntity].
  Future<QuestionEntity> getRandomQuestion();

  /// Inserts an entry to [questionStatusTable] if no entry with the [QuestionId]
  /// exists. Updates the [QuestionStatus] in the [questionStatusTable] if an entry
  /// already exists.
  Future<int> updateQuestionStatus({
    required QuestionStatusModel questionStatusModel,
  });
}
