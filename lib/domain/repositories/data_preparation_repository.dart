import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

import '../failures/failures.dart';

abstract class DataPreparationRepository {
  Future<Either<Failure, bool>> updateQuestionDatabaseIfNeccessary();
  Future<Either<Failure, Database>> initializeSettingsDatabase();
}
