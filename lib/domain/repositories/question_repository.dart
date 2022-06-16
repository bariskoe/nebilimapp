import 'package:dartz/dartz.dart';
import 'package:nebilimapp/domain/entities/question_entity.dart';
import 'package:nebilimapp/domain/failures/failures.dart';

abstract class QuestionRepository {
  Future<Either<Failure, QuestionEntity>> getRandomQuestion();
}
