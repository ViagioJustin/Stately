// Type definitions.

// Transition builder function.
typedef StatelyTransition<Event, In, Out> = Out Function(Event event, In state);

// Side effect function.
typedef SideEffect<Event, State> = void Function(Event event, State state);

/// {@template state_transition_caller}
/// An entry in the [BlocStateGraph] that describes a state [transition]. With an optional [sideEffect]
/// {@endtemplate}
class StatelyTransitionCaller<Event, State> {
  /// {@macro state_transition_caller}
  const StatelyTransitionCaller._({this.transition, this.sideEffect});

  const factory StatelyTransitionCaller.fromTransition({
    StatelyTransition<Event, State, State>? transition,
  }) = StatelyTransitionCaller;

  const factory StatelyTransitionCaller.fromSideEffect({
    SideEffect<Event, State>? sideEffect,
  }) = StatelyTransitionCaller;

  const factory StatelyTransitionCaller({
    StatelyTransition<Event, State, State>? transition,
    SideEffect<Event, State>? sideEffect,
  }) = StatelyTransitionCaller._;

  /// The [transition] that is called when the [StateTransitionCaller] is called.
  final StatelyTransition<Event, State, State>? transition;

  /// The [sideEffect] that is called when the [StateTransitionCaller] is called.
  final SideEffect<Event, State>? sideEffect;
}

// Helper functions.
StatelyTransitionCaller<Event, State>
    transition<Event, State, REvent extends Event, InState extends State>(
  StatelyTransition<REvent, InState, State> transition,
) =>
        StatelyTransitionCaller<Event, State>(
          transition: (event, state) =>
              transition(event as REvent, state as InState),
        );

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

StatelyTransitionCaller<Event, State>
    sideEffect<Event, State, REvent extends Event, InState extends State>(
  SideEffect<REvent, InState> sideEffect,
) =>
        StatelyTransitionCaller<Event, State>(
          sideEffect: (event, state) =>
              sideEffect(event as REvent, state as InState),
        );
