import 'package:equatable/equatable.dart';

class ThinkingTimeModel extends Equatable {
  final bool active;
  final int seconds;
  const ThinkingTimeModel({required this.active, required this.seconds});

  @override
  List<Object?> get props => [
        active,
        seconds,
      ];
}
