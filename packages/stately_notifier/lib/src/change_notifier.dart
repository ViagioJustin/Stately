import 'package:flutter/foundation.dart';
import 'package:stately_core/stately_core.dart';

/// A Stately ChangeNotifier that exposes a single method to add events called "add".
abstract class StatelyChangeNotifier<Event, State> with StatelyGraphMixin<Event, State>, ChangeNotifier {
  StatelyChangeNotifier(this._state) {
    _graph = graph;
  }

  State _state;
  State get state => _state;

  late final StatelyGraph<Event, State> _graph;

  @override
  void add(Event event) {
    final transition = _graph.getTransitionFor(event, state);
    if (transition == null) {
      return;
    }

    // Get the new state based on the transition and then update value.
    final newState = transition.transition?.call(event, state) ?? state;
    
    // Only call if state changed.
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }

    // Now that the new state has been set, let's call sideEffect.
    transition.sideEffect?.call(event, _state);
  }
}
