import 'package:dartz/dartz.dart';
import 'package:nebilimapp/models/question_status_model.dart';
import '../entities/question_entity.dart';
import '../failures/failures.dart';

abstract class QuestionRepository {
  Future<Either<Failure, QuestionEntity>> getRandomQuestion();
  Future<Either<Failure, int>> updateQuestionStatus(
      {required QuestionStatusModel questionStatusModel});
}
