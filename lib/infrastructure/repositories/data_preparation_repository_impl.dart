import '../../domain/failures/failures.dart';

import 'package:dartz/dartz.dart';
import '../datasources/local_sqlite_datasource.dart';

import '../../domain/repositories/data_preparation_repository.dart';

class DataPreparationRepositoryImpl implements DataPreparationRepository {
  final LocalSqliteDataSource localSqliteDataSource;
  DataPreparationRepositoryImpl({
    required this.localSqliteDataSource,
  });

  @override
  Future<Either<Failure, bool>> updateQuestionDatabaseIfNeccessary() async {
    try {
      final updated =
          await localSqliteDataSource.updateQuestionDatabaseIfNeccessary();
      return Right(updated);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
