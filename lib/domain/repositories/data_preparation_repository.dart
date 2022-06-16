import 'package:dartz/dartz.dart';
import 'package:nebilimapp/domain/failures/failures.dart';

abstract class DataPreparationRepository {
  Future<Either<Failure, bool>> updateQuestionDatabaseIfNeccessary();
}
