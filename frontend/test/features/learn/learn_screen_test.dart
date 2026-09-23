import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/domain/unusual_behaviour.dart';
import 'package:frontend/domain/unusual_providers.dart';
import 'package:frontend/features/learn/learn_screen.dart';

void main() {
  testWidgets('recommendation card fits a phone viewport', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final insight = BehaviourInsight(
      category: BehaviourCategory.excessIdle,
      priority: InsightPriority.coaching,
      title: 'Excess idle detected',
      whatHappened: '18 idle min is 12 min above your baseline.',
      likelyReason: 'Waiting-zone congestion or a task coordination delay.',
      recommendedAction:
          'Use standby during waits and confirm the next hand-off early.',
      impact: 'Up to 0.4 L fuel recoverable.',
      detectedAt: DateTime(2026, 9, 23, 8, 5),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          unusualInsightsProvider.overrideWith(
            (ref) => Stream.value([insight]),
          ),
        ],
        child: MaterialApp(
          theme: CatTheme.dark(),
          home: const LearnScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Excess idle detected'), findsOneWidget);
    expect(find.textContaining('0.4 L'), findsOneWidget);
    expect(
      find.text('Engine Idle Shutdown on Cat Next Gen Excavators'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows Cat Operator Training catalog when idle', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          unusualInsightsProvider.overrideWith(
            (ref) => Stream.value(const []),
          ),
        ],
        child: MaterialApp(
          theme: CatTheme.dark(),
          home: const LearnScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cat Operator Training'), findsOneWidget);
    expect(
      find.text('Engine Idle Shutdown on Cat Next Gen Excavators'),
      findsOneWidget,
    );
    expect(
      find.text('2D E-Fence Cab Avoidance on the Next Gen Excavator'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Next Gen HEX E-Fence Overview'),
      200,
    );
    expect(find.text('Next Gen HEX E-Fence Overview'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
