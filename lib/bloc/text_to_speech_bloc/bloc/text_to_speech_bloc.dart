import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../question_bloc/bloc/question_bloc.dart';

import '../../../dependency_injection.dart';

part 'text_to_speech_event.dart';
part 'text_to_speech_state.dart';

class TextToSpeechBloc extends Bloc<TextToSpeechEvent, TextToSpeechState> {
  final FlutterTts flutterTts;

  TextToSpeechBloc({
    required this.flutterTts,
  }) : super(TextToSpeechInitial()) {
    // on<TextToSpeechEvent>((event, emit) async{

    // });

    flutterTts.setVoice({'name': 'en-us-x-tpf-local', 'locale': 'en-US'});

    on<TextToSpeechEventSpeak>((event, emit) async {
      if (event.ttsOn ?? true) {
        flutterTts.setCompletionHandler(() {
          getIt<QuestionBloc>().add(QuestionEventSpeakHasFinished(
            wasAdditionalInfo: event.isAdditionalInfo ?? false,
            wasAnswer: event.isAnswer ?? false,
            wasQuestion: event.isQuestion ?? false,
          ));
        });

        await flutterTts.speak(event.text);
      } else {
        getIt<QuestionBloc>().add(QuestionEventSpeakHasFinished(
          wasAdditionalInfo: event.isAdditionalInfo ?? false,
          wasAnswer: event.isAnswer ?? false,
          wasQuestion: event.isQuestion ?? false,
        ));
      }
    });
    on<TextToSpeechEventStopSpeaking>((event, emit) async {
      await flutterTts.stop();
    });
  }
}
