import 'package:equatable/equatable.dart';
import 'package:nebilimapp/domain/entities/question_status_entity.dart';

class QuestionStatusSettingsModel with EquatableMixin {
  QuestionStatus questionStatus;
  bool ask;

  QuestionStatusSettingsModel({
    required this.questionStatus,
    required this.ask,
  });

  @override
  List<Object?> get props => [
        questionStatus,
        ask,
      ];
}
