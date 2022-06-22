import '../../models/question_model.dart';
import '../../models/question_status_model.dart';

abstract class LocalSqliteDataSource {
  /// Checks if the asset assets/Aktive Fragen Flutter - Sheet2.csv has
  /// the same length as in the last check. If not, this means the csv file
  /// has been updated. All questions in the database will be deleted and the
  /// database will be filled again with the new data
  Future<bool> updateQuestionDatabaseIfNeccessary();

  /// Choses a random question from the database and returns a [QuestionModel].
  Future<QuestionModel> getRandomQuestion();

  /// Returns a [QuestionModel] which hold the data of the question with the
  /// provided [questionId]
  Future<QuestionModel> getQuestionById({required int questionId});

  /// Inserts an entry to [questionStatusTable] if no entry with the [QuestionId]
  /// exists. Updates the [QuestionStatus] in the [questionStatusTable] if an entry
  /// already exists.
  Future<int> updateQuestionStatus({
    required QuestionStatusModel questionStatusModel,
  });

  /// Toggles the Favorite Status of a question if a status exists. Sets it
  /// as [Questionstatus.favorited] if no [QuestionStatus exists]
  Future<int> toggleFavoriteStatus({required int questionId});
}
