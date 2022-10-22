import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../locale/locale.dart';

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

  String getName(BuildContext context) {
    switch (this) {
      case DifficultyEnum.easyPeasy:
        return S.of(context).questionDifficulty1;
      case DifficultyEnum.easy:
        return S.of(context).questionDifficulty2;
      case DifficultyEnum.average:
        return S.of(context).questionDifficulty3;
      case DifficultyEnum.hard:
        return S.of(context).questionDifficulty4;
      case DifficultyEnum.superBrain:
        return S.of(context).questionDifficulty5;
    }
  }

  static DifficultyEnum deserialize(int difficultyAsInt) {
    return DifficultyEnum.values[difficultyAsInt];
  }
}
