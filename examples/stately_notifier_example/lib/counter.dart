import 'package:stately_core/stately_core.dart';
import 'package:stately_notifier/stately_notifier.dart';

sealed class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class CounterValueNotifier extends StatelyValueNotifier<CounterEvent, int> {
  CounterValueNotifier(super.state);

  @override
  StatelyGraph<CounterEvent, int> get graph => StatelyGraph<CounterEvent, int>(
        graph: {
          int: {
            IncrementEvent: transition((CounterEvent event, int state) => state + 1),
            DecrementEvent: transition((CounterEvent event, int state) => state - 1),
          },
        },
      );
}
