import 'package:sqflite/sqflite.dart';

import '/database/database_helper.dart';

import '../../database/settings_database_helper.dart';
import '../../models/question_model.dart';
import '../../models/question_status_model.dart';
import '../../models/settings_model.dart';
import 'local_sqlite_datasource.dart';

class LocalSqliteDataSourceImpl implements LocalSqliteDataSource {
  //! Question Database --------------------------------------------------------
  @override
  Future<bool> updateQuestionDatabaseIfNeccessary() async {
    return await DatabaseHelper.updateQuestionDatabaseIfNecessary();
  }

  @override
  Future<QuestionModel> getRandomQuestion() async {
    return await DatabaseHelper.getRandomQuestion();
  }

  @override
  Future<QuestionModel> getQuestionById({required int questionId}) async {
    return await DatabaseHelper.getQuestionById(questionId: questionId);
  }

  @override
  Future<int> updateQuestionStatus(
      {required QuestionStatusModel questionStatusModel}) async {
    return await DatabaseHelper.updateQuestionStatus(
      questionStatusModel: questionStatusModel,
    );
  }

  @override
  Future<int> toggleFavoriteStatus({required int questionId}) async {
    return await DatabaseHelper.toggleFavoriteStatus(questionId: questionId);
  }

  @override
  Future<int> toggleDontAskAgain({required int questionId}) async {
    return await DatabaseHelper.toggleDontAskAgain(questionId: questionId);
  }

  @override
  Future<int> insertQuestionIdToRecentlyAskedTable(
      {required int questionId}) async {
    return await DatabaseHelper.insertQuestionIdToRecentlyAskedTable(
        questionId: questionId);
  }

  @override
  Future<int> insertTimeToLastTimeAskedTable({
    required int questionId,
  }) async {
    return await DatabaseHelper.insertTimeToLastTimeAskedTable(
        questionId: questionId);
  }

  @override
  Future<QuestionModel> getFilterConformQuestion() async {
    return await DatabaseHelper.getFilterConformQuestion();
  }

  @override
  Future<int> clearRecentlyAskedTable() async {
    return await DatabaseHelper.clearRecentlyAskedTable();
  }

  //! Settings Database --------------------------------------------------------

  @override
  Future<SettingsModel> getAllSettings() async {
    return await SettingsDatabaseHelper.getAllSettings();
  }

  @override
  Future<int> toggleAskCategory({required int categoryAsInt}) async {
    return await SettingsDatabaseHelper.toggleAskCategory(
        categoryAsInt: categoryAsInt);
  }

  @override
  Future<int> toggleAskDifficulty({required int difficultyAsInt}) async {
    return await SettingsDatabaseHelper.toggleAskDifficulty(
        difficultyAsInt: difficultyAsInt);
  }

  @override
  Future<int> toggleAskMarkedAs({required String statusName}) async {
    return await SettingsDatabaseHelper.toggleAskMarkedAs(
        statusName: statusName);
  }

  @override
  Future<int> updateOtherSetting({
    required String otherSettingsName,
    required int newValue,
  }) async {
    return await SettingsDatabaseHelper.updateValueOfOtherSetting(
      nameOfOtherSetting: otherSettingsName,
      value: newValue,
    );
  }

  @override
  Future<Database> functionToInitializeSettingsDatabase() async {
    return await SettingsDatabaseHelper.functionToInitializeSettingsDatabase();
  }
}
