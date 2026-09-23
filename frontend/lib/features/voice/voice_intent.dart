enum VoiceIntent {
  currentEta(label: 'Current ETA', sampleQuestion: "What's my ETA?"),
  nextTask(label: 'Next task', sampleQuestion: "What's my next task?"),
  etaChange(label: 'ETA change', sampleQuestion: 'Why did my ETA change?'),
  fuelRemaining(label: 'Fuel', sampleQuestion: 'How much fuel do I have?'),
  scheduleRecovery(label: 'Schedule', sampleQuestion: 'How far behind am I?'),
  safetyStatus(
    label: 'Safety status',
    sampleQuestion: "What's my current safety status?",
  );

  const VoiceIntent({required this.label, required this.sampleQuestion});

  final String label;
  final String sampleQuestion;
}

class VoiceIntentMatcher {
  const VoiceIntentMatcher();

  VoiceIntent? match(String transcript) {
    final input = transcript
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9\s']"), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (input.isEmpty) return null;

    // Specific ETA-change phrasing must win before the general ETA intent.
    if (_containsAny(input, const [
      'why did my eta',
      'why has my eta',
      'why is my eta',
      'eta change',
      'eta increase',
      'eta decrease',
      'eta longer',
    ])) {
      return VoiceIntent.etaChange;
    }
    if (_containsAny(input, const [
      'next task',
      'what is next',
      "what's next",
      'do next',
      'after this task',
    ])) {
      return VoiceIntent.nextTask;
    }
    if (_containsAny(input, const [
      'fuel',
      'diesel',
      'tank level',
      'range left',
    ])) {
      return VoiceIntent.fuelRemaining;
    }
    if (_containsAny(input, const [
      'how far behind',
      'behind schedule',
      'ahead of schedule',
      'on schedule',
      'schedule status',
      'recover time',
      'recovery time',
    ])) {
      return VoiceIntent.scheduleRecovery;
    }
    if (_containsAny(input, const [
      'safety status',
      'current safety',
      'is it safe',
      'am i safe',
      'hazard',
      'risk status',
      'operational risk',
    ])) {
      return VoiceIntent.safetyStatus;
    }
    if (_containsAny(input, const [
      'eta',
      'time remaining',
      'time left',
      'how much time',
      'how long',
      'finish this task',
      'task finish',
    ])) {
      return VoiceIntent.currentEta;
    }
    return null;
  }

  bool _containsAny(String input, List<String> phrases) {
    return phrases.any(input.contains);
  }
}
