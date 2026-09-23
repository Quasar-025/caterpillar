import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_config.dart';
import '../../core/alert_level.dart';
import '../../data/data_providers.dart';
import '../../domain/eta_providers.dart';
import '../../safety/safety_providers.dart';
import '../../telemetry/machine_mode.dart';
import '../../telemetry/simulator_providers.dart';
import 'voice_answer.dart';
import 'voice_intent.dart';
import 'voice_phrase_service.dart';
import 'voice_services.dart';

final speechRecognitionServiceProvider = Provider<SpeechRecognitionService>((
  ref,
) {
  return DeviceSpeechRecognitionService();
});

final textToSpeechServiceProvider = Provider<TextToSpeechService>((ref) {
  return DeviceTextToSpeechService();
});

final voicePhrasingServiceProvider = Provider<VoicePhrasingService>((ref) {
  final service = BackendVoicePhrasingService(ref.watch(apiBaseUrlProvider));
  ref.onDispose(service.dispose);
  return service;
});

final voiceIntentMatcherProvider = Provider<VoiceIntentMatcher>((ref) {
  return const VoiceIntentMatcher();
});

final voiceAnswerBuilderProvider = Provider<VoiceAnswerBuilder>((ref) {
  return const VoiceAnswerBuilder();
});

final nextOperatorTaskProvider = FutureProvider<String?>((ref) async {
  final tick = ref.watch(telemetryTickProvider).valueOrNull;
  final db = ref.watch(appDatabaseProvider);
  final tasks = await db.select(db.tasks).get();
  final candidates =
      tasks
          .where(
            (task) =>
                task.deletedAt == null &&
                task.progressPct < 100 &&
                task.id != tick?.taskId,
          )
          .toList()
        ..sort((a, b) => a.scheduledStart.compareTo(b.scheduledStart));

  if (candidates.isNotEmpty) {
    return _friendlyTask(candidates.first.taskType);
  }

  return switch (tick?.mode) {
    MachineMode.dig => 'Pipe lift in Zone C',
    MachineMode.lift => 'Finish trench grading in Zone B',
    MachineMode.load => 'Final grading in the east work zone',
    MachineMode.grade || null => null,
  };
});

final voiceContextProvider = Provider<VoiceContext>((ref) {
  final tick = ref.watch(telemetryTickProvider).valueOrNull;
  final eta = ref.watch(etaStateProvider).valueOrNull;
  final recovery = ref.watch(shiftRecoveryProvider);
  final risk = ref.watch(riskStateProvider).valueOrNull;
  final nextTask = ref.watch(nextOperatorTaskProvider).valueOrNull;

  final etaMinutes =
      eta == null || !eta.etaRemainingMin.isFinite || eta.etaRemainingMin < 0
      ? null
      : eta.etaRemainingMin.clamp(0, 720).round();
  final fuel = tick == null || !tick.fuelPct.isFinite
      ? null
      : tick.fuelPct.clamp(0, 100).round();

  return VoiceContext(
    etaMinutes: etaMinutes,
    etaExplanation: eta?.explanation,
    nextTask: nextTask,
    fuelPercent: fuel,
    scheduleSummary: recovery?.summary,
    riskLevel: risk?.level.label ?? 'INFO',
    safetyAction: risk?.action ?? 'No immediate hazards',
    safetyReasons: risk?.reasons ?? const [],
    hasCriticalAlert: risk?.level == AlertLevel.critical,
  );
});

final voiceAssistantProvider =
    StateNotifierProvider<VoiceAssistantController, VoiceAssistantState>((ref) {
      return VoiceAssistantController(
        speech: ref.watch(speechRecognitionServiceProvider),
        tts: ref.watch(textToSpeechServiceProvider),
        matcher: ref.watch(voiceIntentMatcherProvider),
        answerBuilder: ref.watch(voiceAnswerBuilderProvider),
        phrasing: ref.watch(voicePhrasingServiceProvider),
        readContext: () => ref.read(voiceContextProvider),
      );
    });

class VoiceAssistantState {
  const VoiceAssistantState({
    this.isInitializing = false,
    this.isListening = false,
    this.isSpeaking = false,
    this.speechAvailable,
    this.transcript = '',
    this.answer,
    this.errorMessage,
    this.audioMutedForSafety = false,
  });

  final bool isInitializing;
  final bool isListening;
  final bool isSpeaking;
  final bool? speechAvailable;
  final String transcript;
  final VoiceAnswer? answer;
  final String? errorMessage;
  final bool audioMutedForSafety;

  VoiceAssistantState copyWith({
    bool? isInitializing,
    bool? isListening,
    bool? isSpeaking,
    bool? speechAvailable,
    String? transcript,
    VoiceAnswer? answer,
    String? errorMessage,
    bool clearError = false,
    bool? audioMutedForSafety,
  }) {
    return VoiceAssistantState(
      isInitializing: isInitializing ?? this.isInitializing,
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      speechAvailable: speechAvailable ?? this.speechAvailable,
      transcript: transcript ?? this.transcript,
      answer: answer ?? this.answer,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      audioMutedForSafety: audioMutedForSafety ?? this.audioMutedForSafety,
    );
  }
}

class VoiceAssistantController extends StateNotifier<VoiceAssistantState> {
  VoiceAssistantController({
    required SpeechRecognitionService speech,
    required TextToSpeechService tts,
    required VoiceIntentMatcher matcher,
    required VoiceAnswerBuilder answerBuilder,
    required VoicePhrasingService phrasing,
    required VoiceContext Function() readContext,
  }) : _speech = speech,
       _tts = tts,
       _matcher = matcher,
       _answerBuilder = answerBuilder,
       _phrasing = phrasing,
       _readContext = readContext,
       super(const VoiceAssistantState());

  final SpeechRecognitionService _speech;
  final TextToSpeechService _tts;
  final VoiceIntentMatcher _matcher;
  final VoiceAnswerBuilder _answerBuilder;
  final VoicePhrasingService _phrasing;
  final VoiceContext Function() _readContext;

  Future<void> startListening() async {
    if (state.isInitializing || state.isListening) return;
    await _tts.stop();
    state = state.copyWith(
      isInitializing: true,
      isSpeaking: false,
      transcript: '',
      clearError: true,
      audioMutedForSafety: false,
    );

    try {
      final available = await _speech.initialize(
        onError: _onSpeechError,
        onListeningChanged: (listening) {
          if (!mounted) return;
          state = state.copyWith(isListening: listening);
        },
      );
      if (!mounted) return;
      state = state.copyWith(isInitializing: false, speechAvailable: available);
      if (!available) {
        state = state.copyWith(
          errorMessage:
              'Microphone input is unavailable. Choose a quick question '
              'or type below.',
        );
        return;
      }

      state = state.copyWith(isListening: true);
      await _speech.start(
        onResult: (transcript, isFinal) {
          if (!mounted) return;
          state = state.copyWith(transcript: transcript);
          if (isFinal && transcript.trim().isNotEmpty) {
            unawaited(submit(transcript));
          }
        },
      );
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        isInitializing: false,
        isListening: false,
        speechAvailable: false,
        errorMessage:
            'Voice input could not start. Choose a quick question or type '
            'below.',
      );
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    if (!mounted) return;
    state = state.copyWith(isListening: false);
    if (state.transcript.trim().isNotEmpty) {
      await submit(state.transcript);
    }
  }

  Future<void> ask(VoiceIntent intent) {
    return _respond(intent.sampleQuestion, intent);
  }

  Future<void> submit(String transcript) {
    return _respond(transcript, _matcher.match(transcript));
  }

  Future<void> _respond(String transcript, VoiceIntent? intent) async {
    await _speech.stop();
    final context = _readContext();
    final answer = _answerBuilder.build(intent, context);
    if (!mounted) return;
    state = state.copyWith(
      isInitializing: false,
      isListening: false,
      transcript: transcript.trim(),
      answer: answer,
      clearError: true,
      audioMutedForSafety: context.hasCriticalAlert,
    );

    if (context.hasCriticalAlert) {
      await _tts.stop();
      return;
    }

    var response = answer;
    if (intent != null && intent != VoiceIntent.safetyStatus) {
      final phrasedText = await _phrasing.phrase(
        intent: intent == VoiceIntent.etaChange
            ? 'eta_explanation'
            : 'voice_answer',
        facts: context.factsFor(intent),
        fallback: answer.displayText,
      );
      response = VoiceAnswer(
        intent: answer.intent,
        displayText: phrasedText,
        spokenText: phrasedText.replaceAll('ETA', 'E T A'),
      );
      if (!mounted) return;
      state = state.copyWith(answer: response);
    }

    state = state.copyWith(isSpeaking: true);
    try {
      await _tts.speak(response.spokenText);
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        errorMessage:
            'The answer is shown, but spoken playback is unavailable.',
      );
    } finally {
      if (mounted) state = state.copyWith(isSpeaking: false);
    }
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
    if (mounted) state = state.copyWith(isSpeaking: false);
  }

  void _onSpeechError(String message) {
    if (!mounted) return;
    state = state.copyWith(
      isInitializing: false,
      isListening: false,
      errorMessage: message,
    );
  }

  @override
  void dispose() {
    unawaited(_speech.cancel());
    unawaited(_tts.stop());
    super.dispose();
  }
}

String _friendlyTask(String raw) {
  return switch (raw.trim().toUpperCase()) {
    'DIG' || 'TRENCHING' => 'Trenching',
    'LIFT' || 'PIPE_LIFT' => 'Pipe lift',
    'LOAD' || 'TRUCK_LOADING' => 'Truck loading',
    'GRADE' || 'GRADING' => 'Final grading',
    _ =>
      raw
          .trim()
          .toLowerCase()
          .split(RegExp(r'[_\s]+'))
          .where((part) => part.isNotEmpty)
          .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
          .join(' '),
  };
}
