import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/checklist/checklist_provider.dart';

void main() {
  test('start shift stays locked until every required item is checked', () {
    final notifier = ChecklistNotifier();

    expect(notifier.state.allRequiredComplete, isFalse);
    expect(notifier.state.shiftStarted, isFalse);

    notifier.startShift();
    expect(notifier.state.shiftStarted, isFalse);

    notifier.checkAll();
    expect(notifier.state.allRequiredComplete, isTrue);

    notifier.startShift();
    expect(notifier.state.shiftStarted, isTrue);

    notifier.toggle('hard_hat');
    expect(notifier.state.items.firstWhere((i) => i.template.key == 'hard_hat').isChecked, isTrue);
  });
}
