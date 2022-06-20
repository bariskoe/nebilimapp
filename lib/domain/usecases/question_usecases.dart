import 'package:dartz/dartz.dart';

import '../../models/question_status_model.dart';
import '../entities/question_entity.dart';
import '../failures/failures.dart';
import '../repositories/question_repository.dart';

class QuestionUsecases {
  final QuestionRepository questionRepository;

  QuestionUsecases({
    required this.questionRepository,
  });

  Future<Either<Failure, QuestionEntity>> getRandomQuestion() async {
    return await questionRepository.getRandomQuestion();
  }

  Future<Either<Failure, int>> updateQuestionStatus(
      {required QuestionStatusModel questionStatusModel}) async {
    return await questionRepository.updateQuestionStatus(
        questionStatusModel: questionStatusModel);
  }
}
