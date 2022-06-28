import 'package:dartz/dartz.dart';

import '../../models/question_model.dart';
import '../../models/question_status_model.dart';
import '../failures/failures.dart';
import '../repositories/question_repository.dart';

class QuestionUsecases {
  final QuestionRepository questionRepository;

  QuestionUsecases({
    required this.questionRepository,
  });

  Future<Either<Failure, QuestionModel>> getRandomQuestion() async {
    return await questionRepository.getRandomQuestion();
  }

  Future<Either<Failure, QuestionModel>> getFilterConformQuestion() async {
    return await questionRepository.getFilterConformQuestion();
  }

  Future<Either<Failure, QuestionModel>> getQuestionById(
      {required int questionId}) async {
    return await questionRepository.getQuestionById(questionId: questionId);
  }

  Future<Either<Failure, int>> updateQuestionStatus(
      {required QuestionStatusModel questionStatusModel}) async {
    return await questionRepository.updateQuestionStatus(
        questionStatusModel: questionStatusModel);
  }

  Future<Either<Failure, int>> toggleFavoriteStatus(
      {required int questionId}) async {
    return await questionRepository.toggleFavoriteStatus(
        questionId: questionId);
  }

  Future<Either<Failure, int>> toggleDontAskAgain(
      {required int questionId}) async {
    return await questionRepository.toggleDontAskAgain(
      questionId: questionId,
    );
  }
}
