import 'package:nebilimapp/models/question_status_model.dart';

import '../../domain/entities/question_entity.dart';

import 'local_sqlite_datasource.dart';

import '/database/database_helper.dart';

class LocalSqliteDataSourceImpl implements LocalSqliteDataSource {
  @override
  Future<bool> updateQuestionDatabaseIfNeccessary() async {
    return await DatabaseHelper.updateQuestionDatabaseIfNecessary();
  }

  @override
  Future<QuestionEntity> getRandomQuestion() async {
    return await DatabaseHelper.getRandomQuestion();
  }

  @override
  Future<int> updateQuestionStatus(
      {required QuestionStatusModel questionStatusModel}) async {
    return await DatabaseHelper.updateQuestionStatus(
      questionStatusModel: questionStatusModel,
    );
  }
}
