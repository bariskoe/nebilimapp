import 'package:dartz/dartz.dart';

import '../../domain/failures/failures.dart';
import '../../domain/repositories/data_preparation_repository.dart';
import '../datasources/local_sqlite_datasource.dart';

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
