part of 'text_to_speech_bloc.dart';

abstract class TextToSpeechEvent extends Equatable {
  const TextToSpeechEvent();

  @override
  List<Object> get props => [];
}

class TextToSpeechEventSpeak extends TextToSpeechEvent {
  final String text;
  final bool? isQuestion;
  final bool? isAdditionalInfo;
  final bool? isAnswer;

  const TextToSpeechEventSpeak({
    required this.text,
    this.isQuestion,
    this.isAdditionalInfo,
    this.isAnswer,
  });

  @override
  List<Object> get props => [
        text,
        isQuestion ?? false,
        isAdditionalInfo ?? false,
        isAnswer ?? false,
      ];
}
