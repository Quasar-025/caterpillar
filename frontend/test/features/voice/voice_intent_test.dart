import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/voice/voice_answer.dart';
import 'package:frontend/features/voice/voice_intent.dart';

void main() {
  const matcher = VoiceIntentMatcher();

  group('VoiceIntentMatcher', () {
    const cases = <String, VoiceIntent>{
      "What's my ETA?": VoiceIntent.currentEta,
      'How much time is left?': VoiceIntent.currentEta,
      "What's my next task?": VoiceIntent.nextTask,
      'What do I do next?': VoiceIntent.nextTask,
      'Why did my ETA increase?': VoiceIntent.etaChange,
      'Explain the ETA change': VoiceIntent.etaChange,
      'How much fuel do I have?': VoiceIntent.fuelRemaining,
      'Check the diesel level': VoiceIntent.fuelRemaining,
      'How far behind am I?': VoiceIntent.scheduleRecovery,
      'Am I on schedule?': VoiceIntent.scheduleRecovery,
      "What's my current safety status?": VoiceIntent.safetyStatus,
      'Are there any hazards?': VoiceIntent.safetyStatus,
    };

    for (final entry in cases.entries) {
      test('matches "${entry.key}"', () {
        expect(matcher.match(entry.key), entry.value);
      });
    }

    test('prefers ETA change over general ETA', () {
      expect(matcher.match('Why is my ETA longer?'), VoiceIntent.etaChange);
    });

    test('returns null for an unsupported request', () {
      expect(matcher.match('Tell me a joke'), isNull);
    });
  });

  group('VoiceAnswerBuilder', () {
    const builder = VoiceAnswerBuilder();
    const context = VoiceContext(
      etaMinutes: 24,
      etaExplanation:
          'ETA increased by 8 min because cycle time is up 18 percent.',
      nextTask: 'Pipe lift in Zone C',
      fuelPercent: 67,
      scheduleSummary: '12 min behind. About 8 min recoverable at normal pace.',
      riskLevel: 'ACTION',
      safetyAction: 'Stop swing and confirm the worker is clear',
      safetyReasons: ['Worker inside the action zone.'],
      hasCriticalAlert: false,
    );

    test('builds a factual answer for every supported intent', () {
      final answers = {
        for (final intent in VoiceIntent.values)
          intent: builder.build(intent, context).displayText,
      };

      expect(answers[VoiceIntent.currentEta], contains('24 minutes'));
      expect(answers[VoiceIntent.nextTask], contains('Pipe lift'));
      expect(answers[VoiceIntent.etaChange], contains('cycle time'));
      expect(answers[VoiceIntent.fuelRemaining], contains('67 percent'));
      expect(answers[VoiceIntent.scheduleRecovery], contains('12 min behind'));
      expect(answers[VoiceIntent.safetyStatus], contains('ACTION'));
    });

    test('unknown input explains the bounded capability', () {
      final answer = builder.build(null, context);

      expect(answer.intent, isNull);
      expect(answer.displayText, contains('ETA'));
      expect(answer.displayText, contains('safety status'));
    });

    test('missing live data never invents values', () {
      final answer = builder.build(
        VoiceIntent.fuelRemaining,
        const VoiceContext(
          etaMinutes: null,
          etaExplanation: null,
          nextTask: null,
          fuelPercent: null,
          scheduleSummary: null,
          riskLevel: 'INFO',
          safetyAction: 'No immediate hazards',
          safetyReasons: [],
          hasCriticalAlert: false,
        ),
      );

      expect(answer.displayText, contains('unavailable'));
      expect(answer.displayText, isNot(contains('%')));
    });
  });
}
