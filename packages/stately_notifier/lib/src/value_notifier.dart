import 'package:flutter/foundation.dart';
import 'package:stately_core/stately_core.dart';

/// A ValueNotifier that exposes a single method to add events called "add".
abstract class StatelyValueNotifier<Event, State> extends ValueNotifier<State> with StatelyGraphMixin<Event, State> {
  StatelyValueNotifier(super.initalState) {
    _graph = graph;
  }

  late final StatelyGraph<Event, State> _graph;

  @override
  void add(Event event) {
    final transition = _graph.getTransitionFor(event, value);
    if (transition == null) {
      return;
    }

    // Get the new state based on the transition and then update value.
    final newState = transition.transition?.call(event, value) ?? value;
    value = newState;

    // Now that the new state has been set, let's call sideEffect.
    transition.sideEffect?.call(event, value);
  }
}