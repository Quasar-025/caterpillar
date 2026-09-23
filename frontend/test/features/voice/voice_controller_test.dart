import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/voice/voice_answer.dart';
import 'package:frontend/features/voice/voice_intent.dart';
import 'package:frontend/features/voice/voice_providers.dart';
import 'package:frontend/features/voice/voice_services.dart';

void main() {
  VoiceContext context({bool critical = false}) => VoiceContext(
    etaMinutes: 18,
    etaExplanation: 'ETA is stable.',
    nextTask: 'Pipe lift',
    fuelPercent: 74,
    scheduleSummary: 'On schedule.',
    riskLevel: critical ? 'CRITICAL' : 'INFO',
    safetyAction: critical ? 'Stop machine movement' : 'Continue operation',
    safetyReasons: const [],
    hasCriticalAlert: critical,
  );

  test('quick intent shows text and speaks the same factual answer', () async {
    final speech = _FakeSpeech();
    final tts = _FakeTts();
    final controller = VoiceAssistantController(
      speech: speech,
      tts: tts,
      matcher: const VoiceIntentMatcher(),
      answerBuilder: const VoiceAnswerBuilder(),
      readContext: context,
    );
    addTearDown(controller.dispose);

    await controller.ask(VoiceIntent.currentEta);

    expect(controller.state.transcript, "What's my ETA?");
    expect(controller.state.answer?.displayText, contains('18 minutes'));
    expect(tts.spoken.single, contains('18 minutes'));
  });

  test(
    'critical safety state keeps the answer visible and mutes TTS',
    () async {
      final tts = _FakeTts();
      final controller = VoiceAssistantController(
        speech: _FakeSpeech(),
        tts: tts,
        matcher: const VoiceIntentMatcher(),
        answerBuilder: const VoiceAnswerBuilder(),
        readContext: () => context(critical: true),
      );
      addTearDown(controller.dispose);

      await controller.ask(VoiceIntent.safetyStatus);

      expect(controller.state.answer?.displayText, contains('CRITICAL'));
      expect(controller.state.audioMutedForSafety, isTrue);
      expect(tts.spoken, isEmpty);
      expect(tts.stopCalls, greaterThan(0));
    },
  );

  test('unavailable microphone leaves fallback controls usable', () async {
    final controller = VoiceAssistantController(
      speech: _FakeSpeech(available: false),
      tts: _FakeTts(),
      matcher: const VoiceIntentMatcher(),
      answerBuilder: const VoiceAnswerBuilder(),
      readContext: context,
    );
    addTearDown(controller.dispose);

    await controller.startListening();

    expect(controller.state.speechAvailable, isFalse);
    expect(controller.state.isListening, isFalse);
    expect(controller.state.errorMessage, contains('quick question'));

    await controller.submit('How much fuel is left?');
    expect(controller.state.answer?.displayText, contains('74 percent'));
  });

  test('final speech result is matched and answered', () async {
    final speech = _FakeSpeech();
    final controller = VoiceAssistantController(
      speech: speech,
      tts: _FakeTts(),
      matcher: const VoiceIntentMatcher(),
      answerBuilder: const VoiceAnswerBuilder(),
      readContext: context,
    );
    addTearDown(controller.dispose);

    await controller.startListening();
    speech.emit("What's my next task?", isFinal: true);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state.answer?.intent, VoiceIntent.nextTask);
    expect(controller.state.answer?.displayText, contains('Pipe lift'));
  });
}

class _FakeSpeech implements SpeechRecognitionService {
  _FakeSpeech({this.available = true});

  final bool available;
  void Function(String transcript, bool isFinal)? _onResult;
  void Function(bool listening)? _onListeningChanged;

  @override
  bool isListening = false;

  @override
  Future<bool> initialize({
    required void Function(String message) onError,
    required void Function(bool listening) onListeningChanged,
  }) async {
    _onListeningChanged = onListeningChanged;
    return available;
  }

  @override
  Future<void> start({
    required void Function(String transcript, bool isFinal) onResult,
  }) async {
    _onResult = onResult;
    isListening = true;
    _onListeningChanged?.call(true);
  }

  void emit(String transcript, {required bool isFinal}) {
    if (isFinal) {
      isListening = false;
      _onListeningChanged?.call(false);
    }
    _onResult?.call(transcript, isFinal);
  }

  @override
  Future<void> stop() async {
    isListening = false;
    _onListeningChanged?.call(false);
  }

  @override
  Future<void> cancel() => stop();
}

class _FakeTts implements TextToSpeechService {
  final spoken = <String>[];
  int stopCalls = 0;

  @override
  Future<void> speak(String text) async {
    spoken.add(text);
  }

  @override
  Future<void> stop() async {
    stopCalls++;
  }
}
