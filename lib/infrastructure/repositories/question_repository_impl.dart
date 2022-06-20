import 'package:nebilimapp/models/question_status_model.dart';

import '../../domain/failures/failures.dart';
import '../../domain/entities/question_entity.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/question_repository.dart';
import '../datasources/local_sqlite_datasource.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  LocalSqliteDataSource localSqliteDataSource;

  QuestionRepositoryImpl({
    required this.localSqliteDataSource,
  });

  @override
  Future<Either<Failure, QuestionEntity>> getRandomQuestion() async {
    try {
      final model = await localSqliteDataSource.getRandomQuestion();
      return Right(model);
    } catch (e) {
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
}
