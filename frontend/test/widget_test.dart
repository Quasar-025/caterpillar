import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('home screen loads operator shell', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: OperatorApp()));
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

    await tester.pumpWidget(const ProviderScope(child: OperatorApp()));
    await tester.pumpAndSettle();

    expect(find.text('SAFE TO OPERATE'), findsOneWidget);
    expect(find.text('71%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
