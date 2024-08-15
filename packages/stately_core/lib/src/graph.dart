import 'package:stately_core/stately_core.dart';

/// A mixin to be used with any class that provides access to the [StatelyGraph] instance.
mixin StatelyGraphMixin<Event, State> {
  StatelyGraph<Event, State> get graph;

  void add(Event event);
}

/// A class representing a declarative graph that defines every possible Event -> State transitions.
///
/// This concept ensures that a bloc behaves like a FSM (Finite State Machine) where incorrect states
/// are impossible as every possible path is predefined.
///
class StatelyGraph<Event, State> {
  /// {@macro stately_graph}
  const StatelyGraph({
    required this.graph,
    this.unrestrictedGraph = const {},
  });

  // Our graph defition.
  final Map<Type, Map<Type, StatelyTransitionCaller<Event, State>>> graph;

  // An unrestricted graph of events that do not need to match state prior to being called.
  final Map<Type, StatelyTransitionCaller<Event, State>> unrestrictedGraph;

  /// Makes a transition from [state] to [nextState] using [event] based on [graph].
  State call(Event event, State state) {
    final transition = getTransitionFor(event, state);
    // An incorrect transition is simply ignored.
    if (transition == null) return state;
    return transition.transition?.call(event, state) ?? state;
  }

  void callSideEffect(Event event, State state) {
    final transition = getTransitionFor(event, state);
    transition?.sideEffect?.call(event, state);
  }

  StatelyTransitionCaller<Event, State>? getTransitionFor(Event event, State state) {
    final stateEntry = graph[state.runtimeType];
    if (stateEntry != null) {
      final transition = stateEntry[event.runtimeType];
      if (transition != null) return transition;
    }

    final unrestrictedEntry = unrestrictedGraph[event.runtimeType];
    if (unrestrictedEntry != null) return unrestrictedEntry;

    // Nothing found so nothing returned.
    return null;
  }
}
