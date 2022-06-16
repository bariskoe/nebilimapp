import 'package:nebilimapp/domain/failures/failures.dart';
import 'package:nebilimapp/domain/entities/question_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:nebilimapp/domain/repositories/question_repository.dart';
import 'package:nebilimapp/infrastructure/datasources/local_sqlite_datasource.dart';

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
}
