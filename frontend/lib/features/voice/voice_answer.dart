import 'voice_intent.dart';

class VoiceContext {
  const VoiceContext({
    required this.etaMinutes,
    required this.etaExplanation,
    required this.nextTask,
    required this.fuelPercent,
    required this.scheduleSummary,
    required this.riskLevel,
    required this.safetyAction,
    required this.safetyReasons,
    required this.hasCriticalAlert,
  });

  final int? etaMinutes;
  final String? etaExplanation;
  final String? nextTask;
  final int? fuelPercent;
  final String? scheduleSummary;
  final String riskLevel;
  final String safetyAction;
  final List<String> safetyReasons;
  final bool hasCriticalAlert;

  Map<String, Object?> factsFor(VoiceIntent? intent) {
    return switch (intent) {
      VoiceIntent.currentEta => {'eta_remaining_min': etaMinutes},
      VoiceIntent.nextTask => {'next_task': nextTask},
      VoiceIntent.etaChange => {'eta_explanation': etaExplanation},
      VoiceIntent.fuelRemaining => {'fuel_remaining_pct': fuelPercent},
      VoiceIntent.scheduleRecovery => {'schedule_summary': scheduleSummary},
      VoiceIntent.safetyStatus => {
        'risk_level': riskLevel,
        'action': safetyAction,
        'reasons': safetyReasons,
      },
      null => const {},
    };
  }
}

class VoiceAnswer {
  const VoiceAnswer({
    required this.displayText,
    required this.spokenText,
    required this.intent,
  });

  final String displayText;
  final String spokenText;
  final VoiceIntent? intent;
}

class VoiceAnswerBuilder {
  const VoiceAnswerBuilder();

  VoiceAnswer build(VoiceIntent? intent, VoiceContext context) {
    if (intent == null) {
      return const VoiceAnswer(
        intent: null,
        displayText:
            'I can help with ETA, next task, ETA changes, fuel, schedule, '
            'or safety status.',
        spokenText:
            'I can help with E T A, next task, E T A changes, fuel, '
            'schedule, or safety status.',
      );
    }

    return switch (intent) {
      VoiceIntent.currentEta => _eta(context),
      VoiceIntent.nextTask => _nextTask(context),
      VoiceIntent.etaChange => _etaChange(context),
      VoiceIntent.fuelRemaining => _fuel(context),
      VoiceIntent.scheduleRecovery => _schedule(context),
      VoiceIntent.safetyStatus => _safety(context),
    };
  }

  VoiceAnswer _eta(VoiceContext context) {
    final eta = context.etaMinutes;
    if (eta == null) {
      return _answer(
        VoiceIntent.currentEta,
        'ETA is not available yet. Start the task or wait for live telemetry.',
      );
    }
    if (eta == 0) {
      return _answer(VoiceIntent.currentEta, 'The current task is complete.');
    }
    return _answer(
      VoiceIntent.currentEta,
      'Current task ETA is $eta ${eta == 1 ? 'minute' : 'minutes'}.',
    );
  }

  VoiceAnswer _nextTask(VoiceContext context) {
    final nextTask = context.nextTask?.trim();
    return _answer(
      VoiceIntent.nextTask,
      nextTask == null || nextTask.isEmpty
          ? 'No next task is scheduled after the current task.'
          : 'Your next task is $nextTask.',
    );
  }

  VoiceAnswer _etaChange(VoiceContext context) {
    final explanation = context.etaExplanation?.trim();
    return _answer(
      VoiceIntent.etaChange,
      explanation == null || explanation.isEmpty
          ? 'ETA is stable. It is currently based on your recent cycle pace.'
          : explanation,
    );
  }

  VoiceAnswer _fuel(VoiceContext context) {
    final fuel = context.fuelPercent;
    return _answer(
      VoiceIntent.fuelRemaining,
      fuel == null
          ? 'Fuel level is unavailable until live machine telemetry starts.'
          : 'Fuel remaining is $fuel percent.',
    );
  }

  VoiceAnswer _schedule(VoiceContext context) {
    final summary = context.scheduleSummary?.trim();
    return _answer(
      VoiceIntent.scheduleRecovery,
      summary == null || summary.isEmpty
          ? 'Schedule recovery is not available yet.'
          : summary,
    );
  }

  VoiceAnswer _safety(VoiceContext context) {
    final reason = context.safetyReasons.isEmpty
        ? ''
        : ' ${context.safetyReasons.first}';
    return _answer(
      VoiceIntent.safetyStatus,
      'Operational risk is ${context.riskLevel}. '
      '${context.safetyAction}.$reason',
    );
  }

  VoiceAnswer _answer(VoiceIntent intent, String text) {
    return VoiceAnswer(
      intent: intent,
      displayText: text,
      spokenText: text.replaceAll('ETA', 'E T A'),
    );
  }
}
