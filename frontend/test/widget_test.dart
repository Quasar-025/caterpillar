import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/features/checklist/checklist_provider.dart';
import 'package:frontend/main.dart';

ChecklistNotifier _startedShift() {
  final notifier = ChecklistNotifier();
  notifier.checkAll();
  notifier.startShift();
  return notifier;
}

void main() {
  testWidgets('pre-shift checklist gates the operator shell', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: OperatorApp()));
    await tester.pumpAndSettle();

    expect(find.text('Pre-Shift Inspection'), findsOneWidget);
    expect(find.text('Start Shift'), findsOneWidget);
    expect(find.text('CAT OPERATOR COPILOT'), findsNothing);

    await tester.tap(find.text('Check All'));
    await tester.pump();
    await tester.tap(find.text('Start Shift'));
    await tester.pumpAndSettle();

    expect(find.text('CAT OPERATOR COPILOT'), findsOneWidget);
    expect(find.text('SAFE TO OPERATE'), findsOneWidget);
  });

  testWidgets('home screen loads operator shell', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          checklistProvider.overrideWith((ref) => _startedShift()),
        ],
        child: const OperatorApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CAT OPERATOR COPILOT'), findsOneWidget);
    expect(find.text('SAFE TO OPERATE'), findsOneWidget);
    expect(find.text('Trenching'), findsWidgets);
    expect(find.text('Shift brief'), findsOneWidget);
    expect(find.text('Safety'), findsWidgets);
  });

  testWidgets('home screen adapts to a phone viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          checklistProvider.overrideWith((ref) => _startedShift()),
        ],
        child: const OperatorApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SAFE TO OPERATE'), findsOneWidget);
    expect(find.text('71%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
