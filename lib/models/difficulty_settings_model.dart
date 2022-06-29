import 'package:equatable/equatable.dart';

class DifficultySettingsModel with EquatableMixin {
  DifficultyEnum difficultyEnum;
  bool ask;

  DifficultySettingsModel({
    required this.difficultyEnum,
    required this.ask,
  });

  @override
  List<Object?> get props => [
        difficultyEnum,
        ask,
      ];
}

enum DifficultyEnum {
  easyPeasy,
  easy,
  average,
  hard,
  superBrain,
}

extension DifficultyExtension on DifficultyEnum {
  int get getDifficultyAsInt => DifficultyEnum.values.indexOf(this);
  String get getDifficultyName => name;

  static DifficultyEnum deserialize(int difficultyAsInt) {
    return DifficultyEnum.values[difficultyAsInt];
  }
}
