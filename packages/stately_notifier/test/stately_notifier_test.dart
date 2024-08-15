import 'package:flutter_test/flutter_test.dart';
import 'package:stately_core/stately_core.dart';

import 'package:stately_notifier/stately_notifier.dart';

class ExampleEvent {
  const ExampleEvent(this.value);

  final String value;
}

class ExampleChangeNotifier extends StatelyChangeNotifier<ExampleEvent, String> {
  ExampleChangeNotifier(super.state);

  @override
  StatelyGraph<ExampleEvent, String> get graph => StatelyGraph<ExampleEvent, String>(
        graph: {
          String: {
            ExampleEvent: transition((ExampleEvent event, String state) => event.value),
          },
        },
      );
}

class ExampleValueNotifier extends StatelyChangeNotifier<ExampleEvent, String> {
  ExampleValueNotifier(super.state);

  @override
  StatelyGraph<ExampleEvent, String> get graph => StatelyGraph<ExampleEvent, String>(
        graph: {
          String: {
            ExampleEvent: transition((ExampleEvent event, String state) => event.value),
          },
        },
      );
}

void main() {
  test('ChangeNotifier updates with events', () {
    final notifier = ExampleChangeNotifier('test');
    expect(notifier.state, 'test');
    notifier.add(const ExampleEvent('new'));
    expect(notifier.state, 'new');
  });

  test('ValueNotifier updates with events', () {
    final notifier = ExampleChangeNotifier('test');
    expect(notifier.state, 'test');
    notifier.add(const ExampleEvent('new'));
    expect(notifier.state, 'new');
  });
}
