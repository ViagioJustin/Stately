import 'package:flutter_test/flutter_test.dart';
import 'package:stately_core/stately_core.dart';
import 'package:riverpod/riverpod.dart';
import 'package:stately_riverpod/src/stately_async_notifier.dart';

import 'package:stately_riverpod/stately_riverpod.dart';

final exampleProvider = NotifierProvider<ExampleNotifier, String>(ExampleNotifier.new);
final exampleAsyncProvider = AsyncNotifierProvider<ExampleAsyncNotifier, String>(ExampleAsyncNotifier.new);

class ExampleEvent {
  const ExampleEvent(this.value);

  final String value;
}

class ExampleNotifier extends StatelySyncNotifier<ExampleEvent, String> {
  @override
  String build() {
    return 'start';
  }

  @override
  StatelyGraph<ExampleEvent, String> get graph => StatelyGraph<ExampleEvent, String>(
        graph: {
          String: {
            ExampleEvent: transition((ExampleEvent event, String state) => event.value),
          },
        },
      );
}

class ExampleAsyncNotifier extends StatelyAsyncNotifier<ExampleEvent, String> {
  @override
  Future<String> build() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return 'start';
  }

  @override
  StatelyGraph<ExampleEvent, AsyncValue<String>> get graph => StatelyGraph<ExampleEvent, AsyncValue<String>>(
        graph: {
          AsyncData<String>: {
            ExampleEvent: transition(
              (ExampleEvent event, AsyncData<String> state) => AsyncData(event.value),
            ),
          },
        },
      );
}

void main() {
  test('Notifier can be read from container', () {
    final container = ProviderContainer();
    final notifier = container.read(exampleProvider.notifier);
    expect(notifier, isA<ExampleNotifier>());

    // Now read state.
    final state = container.read(exampleProvider);
    expect(state, 'start');

    // Add event to notifier.
    notifier.add(const ExampleEvent('end'));
    final newState = container.read(exampleProvider);
    expect(newState, 'end');
  });

  test('AsyncNotifier can be read from container', () async {
    final container = ProviderContainer();
    final notifier = container.read(exampleAsyncProvider.notifier);
    expect(notifier, isA<ExampleAsyncNotifier>());

    // Now read state.
    final state = container.read(exampleAsyncProvider);
    expect(state, isA<AsyncLoading>());

    // Pass time for the notifier to load.
    await Future.delayed(const Duration(milliseconds: 200));
    final state2 = container.read(exampleAsyncProvider);
    expect(state2, isA<AsyncData<String>>());
    expect(state2, const AsyncData('start'));

    // Add event to notifier.
    notifier.add(const ExampleEvent('end'));
    final newState = container.read(exampleAsyncProvider);
    expect(newState, isA<AsyncData<String>>());
    expect(newState, const AsyncData('end'));
  });
}
