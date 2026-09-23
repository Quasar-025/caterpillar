import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/core/alert_level.dart';

void main() {
  test('alert ranks increase from info to critical', () {
    expect(AlertLevel.info.rank, lessThan(AlertLevel.attention.rank));
    expect(AlertLevel.attention.rank, lessThan(AlertLevel.action.rank));
    expect(AlertLevel.action.rank, lessThan(AlertLevel.critical.rank));
    expect(AlertLevel.critical.label, 'CRITICAL');
  });
}
