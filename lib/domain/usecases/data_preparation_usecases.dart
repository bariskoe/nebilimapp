import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../repositories/data_preparation_repository.dart';

class DataPreparationUsecases {
  DataPreparationRepository dataPreparationRepository;

  DataPreparationUsecases({required this.dataPreparationRepository});

  Future<Either<Failure, bool>> updateQuestionDatabaseIfNeccessary() async {
    return await dataPreparationRepository.updateQuestionDatabaseIfNeccessary();
  }
}
