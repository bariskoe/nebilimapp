// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'animation_bloc.dart';

abstract class AnimationState extends Equatable {
  const AnimationState();

  @override
  List<Object> get props => [];
}

class AnimationInitial extends AnimationState {
  final int totalAnimationDuration;
  const AnimationInitial({
    required this.totalAnimationDuration,
  });

  @override
  List<Object> get props => [
        totalAnimationDuration,
      ];
}

class AnimationStateThinkingTimeAnimationRunning extends AnimationState {
  final int totalAnimationDuration;
  const AnimationStateThinkingTimeAnimationRunning({
    required this.totalAnimationDuration,
  });

  @override
  List<Object> get props => [
        totalAnimationDuration,
      ];
}

class AnimationStateError extends AnimationState {}
