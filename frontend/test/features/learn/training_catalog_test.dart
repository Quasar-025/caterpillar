import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/domain/unusual_behaviour.dart';
import 'package:frontend/features/learn/training_catalog.dart';

void main() {
  test('surfaces idle shutdown training when excess idle is detected', () {
    final insight = BehaviourInsight(
      category: BehaviourCategory.excessIdle,
      priority: InsightPriority.coaching,
      title: 'Excess idle detected',
      whatHappened: 'Idle is above baseline.',
      likelyReason: 'Waiting-zone delay.',
      recommendedAction: 'Use standby during waits.',
      impact: 'Save fuel.',
      detectedAt: DateTime(2026, 9, 24),
    );

    final modules = recommendedTrainingFor([insight]);
    expect(modules, hasLength(1));
    expect(modules.single.id, 'engine-idle-shutdown');
  });
}
