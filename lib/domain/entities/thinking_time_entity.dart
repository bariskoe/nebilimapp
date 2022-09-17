// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:nebilimapp/models/thinking_time_model.dart';
import 'package:nebilimapp/utils/utils.dart';

class ThinkingTimeEntity {
  int active;
  int secondsToThink;
  ThinkingTimeEntity({
    required this.active,
    required this.secondsToThink,
  });

  ThinkingTimeModel toModel() {
    final model =
        ThinkingTimeModel(active: intToBool(active), seconds: secondsToThink);
    return model;
  }

  factory ThinkingTimeEntity.fromModel({required ThinkingTimeModel model}) {
    final entity = ThinkingTimeEntity(
        active: boolToInt(model.active), secondsToThink: model.seconds);
    return entity;
  }
}
