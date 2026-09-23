import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

abstract interface class SpeechRecognitionService {
  bool get isListening;

  Future<bool> initialize({
    required void Function(String message) onError,
    required void Function(bool listening) onListeningChanged,
  });

  Future<void> start({
    required void Function(String transcript, bool isFinal) onResult,
  });

  Future<void> stop();
  Future<void> cancel();
}

class DeviceSpeechRecognitionService implements SpeechRecognitionService {
  DeviceSpeechRecognitionService([SpeechToText? speech])
    : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  void Function(String message)? _onError;
  void Function(bool listening)? _onListeningChanged;

  @override
  bool get isListening => _speech.isListening;

  @override
  Future<bool> initialize({
    required void Function(String message) onError,
    required void Function(bool listening) onListeningChanged,
  }) async {
    _onError = onError;
    _onListeningChanged = onListeningChanged;
    return _speech.initialize(
      onError: (error) => _onError?.call(_messageFor(error.errorMsg)),
      onStatus: (status) {
        _onListeningChanged?.call(status == SpeechToText.listeningStatus);
      },
      finalTimeout: const Duration(seconds: 2),
    );
  }

  @override
  Future<void> start({
    required void Function(String transcript, bool isFinal) onResult,
  }) async {
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
        listenFor: const Duration(seconds: 12),
        pauseFor: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Future<void> stop() => _speech.stop();

  @override
  Future<void> cancel() => _speech.cancel();

  String _messageFor(String code) {
    if (code.contains('permission')) {
      return 'Microphone permission is off. Use a quick question below or '
          'enable microphone access in device settings.';
    }
    if (code.contains('no_match') || code.contains('speech_timeout')) {
      return 'I did not catch that. Try again or choose a quick question.';
    }
    if (code.contains('network')) {
      return 'Speech recognition is unavailable. Quick questions still work.';
    }
    return 'Voice input is unavailable. Use a quick question below.';
  }
}

abstract interface class TextToSpeechService {
  Future<void> speak(String text);
  Future<void> stop();
}

class DeviceTextToSpeechService implements TextToSpeechService {
  DeviceTextToSpeechService([FlutterTts? tts]) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  bool _configured = false;

  Future<void> _configure() async {
    if (_configured) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.46);
    await _tts.setVolume(1);
    await _tts.awaitSpeakCompletion(true);
    _configured = true;
  }

  @override
  Future<void> speak(String text) async {
    await _configure();
    await _tts.stop();
    await _tts.speak(text, focus: true);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}
