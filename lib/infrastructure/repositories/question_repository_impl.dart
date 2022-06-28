import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../domain/failures/failures.dart';
import '../../domain/repositories/question_repository.dart';
import '../../models/question_model.dart';
import '../../models/question_status_model.dart';
import '../datasources/local_sqlite_datasource.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  LocalSqliteDataSource localSqliteDataSource;

  QuestionRepositoryImpl({
    required this.localSqliteDataSource,
  });

  @override
  Future<Either<Failure, QuestionModel>> getRandomQuestion() async {
    try {
      final model = await localSqliteDataSource.getRandomQuestion();
      return Right(model);
    } catch (e) {
      Logger().e(
          'Error in QuestionRepositoryImpl getRandomQuestion: ${e.toString()}');
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, QuestionModel>> getFilterConformQuestion() async {
    try {
      final model = await localSqliteDataSource.getFilterConformQuestion();
      return Right(model);
    } catch (e) {
      Logger().e(
          'Error in QuestionRepositoryImpl getRandomQuestion: ${e.toString()}');
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, QuestionModel>> getQuestionById(
      {required int questionId}) async {
    try {
      final model =
          await localSqliteDataSource.getQuestionById(questionId: questionId);
      return Right(model);
    } catch (e) {
      Logger().e(
          'Error in QuestionRepositoryImpl getQuestionById: ${e.toString()}');
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> updateQuestionStatus(
      {required QuestionStatusModel questionStatusModel}) async {
    try {
      int success = await localSqliteDataSource.updateQuestionStatus(
          questionStatusModel: questionStatusModel);
      return Right(success);
    } catch (e) {
      return Left(
        DatabaseFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, int>> toggleFavoriteStatus(
      {required int questionId}) async {
    try {
      final success = await localSqliteDataSource.toggleFavoriteStatus(
          questionId: questionId);
      return Right(success);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> toggleDontAskAgain(
      {required int questionId}) async {
    try {
      final success = await localSqliteDataSource.toggleDontAskAgain(
          questionId: questionId);
      return Right(success);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
