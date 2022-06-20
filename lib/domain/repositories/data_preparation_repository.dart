import 'package:dartz/dartz.dart';
import '../failures/failures.dart';

abstract class DataPreparationRepository {
  Future<Either<Failure, bool>> updateQuestionDatabaseIfNeccessary();
}
