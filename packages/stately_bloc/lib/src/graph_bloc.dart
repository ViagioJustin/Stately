import 'package:bloc/bloc.dart';
import 'package:stately_core/stately_core.dart';

/// The [StatelyGraphBloc] is a [Bloc] that uses a [StatelyGraph] to determine the next state based on the event.
///
/// This underlying architecture is simple here; a single event handler that is called for any [Event] that is
/// then passed to the _handleGraphEvent function. This function uses the [graph] to determine the next state.
abstract class StatelyGraphBloc<Event, State> extends Bloc<Event, State> with StatelyGraphMixin<Event, State> {
  StatelyGraphBloc(super.initialState) {
    // configure a single on<Event> handler that passes the event to the _handleGraphEvent function
    // that's in charge of using [graph] to determine the next state.
    on<Event>((event, emit) => _handleGraphEvent(event, emit));
    _graph = graph;
  }

  late final StatelyGraph<Event, State> _graph;

  // Handle the event by getting the transition from the graph and then emitting the new state.
  void _handleGraphEvent(Event event, Emitter emit) {
    final transition = _graph.getTransitionFor(event, state);
    if (transition == null) {
      return;
    }

    // Get the new state based on the transition and then emit.
    final newState = transition.transition?.call(event, state) ?? state;
    emit(newState);

    // Now that the new state has been emitted, let's call sideEffect.
    transition.sideEffect?.call(event, state);
  }
}
