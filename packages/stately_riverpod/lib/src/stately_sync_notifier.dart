import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stately_core/stately_core.dart';

abstract class StatelySyncNotifier<Event, State> extends Notifier<State> with StatelyGraphMixin<Event, State> {
  StatelySyncNotifier() {
    _graph = graph;
  }

  late final StatelyGraph<Event, State> _graph;

  @override
  void add(Event event) {
    final transition = _graph.getTransitionFor(event, state);
    if (transition == null) {
      return;
    }

    // Get the new state based on the transition and then update value.
    final newState = transition.transition?.call(event, state) ?? state;
    state = newState;

    // Now that the new state has been set, let's call sideEffect.
    transition.sideEffect?.call(event, state);
  }
}
