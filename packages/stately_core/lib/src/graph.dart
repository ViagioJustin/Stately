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
/// Each [Event] is mapped to a [State] transition function that is called when the event is triggered.
/// These can be created using the [transition] function which creates a [StatelyTransitionCaller] instance.
/// 
/// If you need to run a side effect when a transition is made, you can use the [sideEffect] function.
/// This function creates a [StatelyTransitionCaller] instance with a side effect.
/// 
/// If you need to run async code you should have it be called from a side effect. This keeps the state machines
/// fully synchronous and predictable. Rather than waiting for Futures to complete to handle side effects, you
/// should instead utilize a property on your state to denote if you are waiting or can use a sealed class and
/// have a state that represents the loading state.
class StatelyGraph<Event, State> {
  /// {@macro stately_graph}
  const StatelyGraph({
    required this.graph,
    this.unrestrictedGraph = const {},
  });

  // The graph definition of [Event] -> [State] transitions.
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

  /// Calls the side effect for the [event] and [state] if it exists.
  void callSideEffect(Event event, State state) {
    final transition = getTransitionFor(event, state);
    transition?.sideEffect?.call(event, state);
  }

  /// Returns the [StatelyTransitionCaller] for the given [event] and [state].
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
