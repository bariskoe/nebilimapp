import 'package:dartz/dartz.dart';
import 'package:nebilimapp/domain/failures/failures.dart';
import 'package:nebilimapp/domain/repositories/data_preparation_repository.dart';

class DataPreparationUsecases {
  DataPreparationRepository dataPreparationRepository;

  DataPreparationUsecases({required this.dataPreparationRepository});

  Future<Either<Failure, bool>> updateQuestionDatabaseIfNeccessary() async {
    return await dataPreparationRepository.updateQuestionDatabaseIfNeccessary();
  }
}
