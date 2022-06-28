import 'package:dartz/dartz.dart';

import '../../models/question_model.dart';
import '../../models/question_status_model.dart';
import '../failures/failures.dart';

abstract class QuestionRepository {
  Future<Either<Failure, QuestionModel>> getRandomQuestion();
  Future<Either<Failure, QuestionModel>> getFilterConformQuestion();
  Future<Either<Failure, QuestionModel>> getQuestionById(
      {required int questionId});

  Future<Either<Failure, int>> updateQuestionStatus(
      {required QuestionStatusModel questionStatusModel});

  Future<Either<Failure, int>> toggleFavoriteStatus({required int questionId});
  Future<Either<Failure, int>> toggleDontAskAgain({required int questionId});
}
