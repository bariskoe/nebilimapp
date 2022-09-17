// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'animation_bloc.dart';

abstract class AnimationEvent extends Equatable {
  const AnimationEvent();

  @override
  List<Object> get props => [];
}

class AnimationEventStartThinkingTimeAnimation extends AnimationEvent {
  final int totalAnimationDuration;
  const AnimationEventStartThinkingTimeAnimation({
    required this.totalAnimationDuration,
  });

  @override
  List<Object> get props => [
        totalAnimationDuration,
      ];
}

class AnimationEventResetAnimation extends AnimationEvent {}
