import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/features/voice/voice_answer.dart';
import 'package:frontend/features/voice/voice_panel.dart';
import 'package:frontend/features/voice/voice_providers.dart';
import 'package:frontend/features/voice/voice_services.dart';

void main() {
  const voiceContext = VoiceContext(
    etaMinutes: 22,
    etaExplanation: 'ETA increased by 4 min because the ground is softer.',
    nextTask: 'Pipe lift in Zone C',
    fuelPercent: 68,
    scheduleSummary: 'On schedule.',
    riskLevel: 'INFO',
    safetyAction: 'Continue operation',
    safetyReasons: [],
    hasCriticalAlert: false,
  );

  testWidgets('panel fits a phone and keeps answers visible as text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          speechRecognitionServiceProvider.overrideWithValue(_NoMicSpeech()),
          textToSpeechServiceProvider.overrideWithValue(_SilentTts()),
          voiceContextProvider.overrideWithValue(voiceContext),
        ],
        child: MaterialApp(
          theme: CatTheme.dark(),
          home: const Scaffold(body: VoiceAssistantPanel()),
        ),
      ),
    );

    expect(find.text('Operator Assistant'), findsOneWidget);
    expect(find.text('Current ETA'), findsOneWidget);
    expect(find.text('Next task'), findsOneWidget);
    expect(find.text('ETA change'), findsOneWidget);
    expect(find.text('Fuel'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Safety status'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Current ETA'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Current task ETA is 22 minutes'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('unavailable microphone explains the fallback', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          speechRecognitionServiceProvider.overrideWithValue(_NoMicSpeech()),
          textToSpeechServiceProvider.overrideWithValue(_SilentTts()),
          voiceContextProvider.overrideWithValue(voiceContext),
        ],
        child: MaterialApp(
          theme: CatTheme.dark(),
          home: const Scaffold(body: VoiceAssistantPanel()),
        ),
      ),
    );

    await tester.tap(find.text('PUSH TO TALK'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Microphone input is unavailable'),
      findsOneWidget,
    );
    expect(find.text('Current ETA'), findsOneWidget);
  });
}

class _NoMicSpeech implements SpeechRecognitionService {
  @override
  bool get isListening => false;

  @override
  Future<bool> initialize({
    required void Function(String message) onError,
    required void Function(bool listening) onListeningChanged,
  }) async => false;

  @override
  Future<void> start({
    required void Function(String transcript, bool isFinal) onResult,
  }) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> cancel() async {}
}

class _SilentTts implements TextToSpeechService {
  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}
}
