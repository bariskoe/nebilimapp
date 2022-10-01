import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

import '../failures/failures.dart';
import '../repositories/data_preparation_repository.dart';

class DataPreparationUsecases {
  DataPreparationRepository dataPreparationRepository;

  DataPreparationUsecases({required this.dataPreparationRepository});

  Future<Either<Failure, bool>> updateQuestionDatabaseIfNeccessary() async {
    return await dataPreparationRepository.updateQuestionDatabaseIfNeccessary();
  }

  Future<Either<Failure, Database>> initializeSettingsDatabase() async {
    return await dataPreparationRepository.initializeSettingsDatabase();
  }
}
