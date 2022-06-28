import '../../models/settings_model.dart';

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

  /// Returns a [QuestionModel] which was built based on filter preferences
  Future<QuestionModel> getFilterConformQuestion();

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

  /// Marks the question as 'dontShowAgain' in the [QuestionStatusTable]
  Future<int> toggleDontAskAgain({required int questionId});

  /// Returns a SettingsModel which holds all settings for the Questionfilters etc
  /// (Category Settings, QuestionsStatus Settings etc.)
  Future<SettingsModel> getAllSettings();

  /// Sets the [ask] field of a row in the [categorySettingsTable] to 1 if its
  /// current value is 0, and to 0 if its current value is 1.
  Future<int> toggleAskCategory({required int categoryAsInt});
}
