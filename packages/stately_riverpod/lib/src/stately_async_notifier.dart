import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:stately_core/stately_core.dart';

abstract class StatelyAsyncNotifier<Event, State> extends AsyncNotifier<State> with StatelyGraphMixin<Event, AsyncValue<State>> {
  StatelyAsyncNotifier() {
    _graph = graph;
  }

  late final StatelyGraph<Event, AsyncValue<State>> _graph;

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
