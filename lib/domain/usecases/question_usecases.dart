import 'package:dartz/dartz.dart';
import 'package:nebilimapp/domain/entities/question_entity.dart';
import 'package:nebilimapp/domain/failures/failures.dart';
import 'package:nebilimapp/domain/repositories/question_repository.dart';
import 'package:nebilimapp/models/question_model.dart';

class QuestionUsecases {
  final QuestionRepository questionRepository;

  QuestionUsecases({
    required this.questionRepository,
  });

  Future<Either<Failure, QuestionEntity>> getRandomQuestion() async {
    return await questionRepository.getRandomQuestion();
  }
}
