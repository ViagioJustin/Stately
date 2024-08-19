// Type definitions.

// Transition builder function.
typedef StatelyTransition<Event, In, Out> = Out Function(Event event, In state);

// Side effect function.
typedef SideEffect<Event, State> = void Function(Event event, State state);

/// {@template state_transition_caller}
/// An entry in the [StatelyGraph] that describes a state [transition]. Can have an optional [sideEffect].
/// 
/// This is used to define the transitions between states in a [StatelyGraph]. Each [StatelyTransitionCaller]
/// defines a single transition to a [state] based on an [event]. Asynchronouse code should be handled in a
/// [sideEffect] rather than in the transition itself. This keeps the states synchronous and predictable.
/// 
/// [sideEffect]s are always called after the transition is made.
/// {@endtemplate}
class StatelyTransitionCaller<Event, State> {
  /// {@macro state_transition_caller}
  const StatelyTransitionCaller._({this.transition, this.sideEffect});

  /// Creates a [StatelyTransitionCaller] from a [transition] without a side effect.
  const factory StatelyTransitionCaller.fromTransition({
    StatelyTransition<Event, State, State>? transition,
  }) = StatelyTransitionCaller;

  /// Creates a [StatelyTransitionCaller] from a [sideEffect] without a transition.
  const factory StatelyTransitionCaller.fromSideEffect({
    SideEffect<Event, State>? sideEffect,
  }) = StatelyTransitionCaller;

  /// Creates a [StatelyTransitionCaller] with both a [transition] and an optional [sideEffect].
  const factory StatelyTransitionCaller({
    StatelyTransition<Event, State, State>? transition,
    SideEffect<Event, State>? sideEffect,
  }) = StatelyTransitionCaller._;

  /// The [transition] that is called when the [StateTransitionCaller] is called.
  final StatelyTransition<Event, State, State>? transition;

  /// The [sideEffect] that is called when the [StateTransitionCaller] is called.
  final SideEffect<Event, State>? sideEffect;
}

/// Helper fumction to create a [StatelyTransitionCaller] from a [transition].
StatelyTransitionCaller<Event, State>
    transition<Event, State, REvent extends Event, InState extends State>(
  StatelyTransition<REvent, InState, State> transition,
) =>
        StatelyTransitionCaller.fromTransition(
          transition: (event, state) =>
              transition(event as REvent, state as InState),
        );

/// Helper function to create a [StatelyTransitionCaller] from a [transition] and a [sideEffect].
StatelyTransitionCaller<Event, State> transitionWithEffect<Event, State,
        REvent extends Event, InState extends State>(
  StatelyTransition<REvent, InState, State> transition,
  SideEffect<REvent, InState> sideEffect,
) =>
    StatelyTransitionCaller<Event, State>(
      transition: (event, state) =>
          transition(event as REvent, state as InState),
      sideEffect: (event, state) =>
          sideEffect(event as REvent, state as InState),
    );

/// Helper function to create a [StatelyTransitionCaller] from a [sideEffect].
StatelyTransitionCaller<Event, State>
    sideEffect<Event, State, REvent extends Event, InState extends State>(
  SideEffect<REvent, InState> sideEffect,
) =>
        StatelyTransitionCaller.fromSideEffect(
          sideEffect: (event, state) =>
              sideEffect(event as REvent, state as InState),
        );
