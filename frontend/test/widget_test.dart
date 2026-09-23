import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('home screen loads operator shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: OperatorApp()));
    await tester.pumpAndSettle();

    expect(find.text('CAT OPERATOR COPILOT'), findsOneWidget);
    expect(find.text('MACHINE STATUS: NORMAL'), findsOneWidget);
    expect(find.text('Safety'), findsOneWidget);
  });
}
