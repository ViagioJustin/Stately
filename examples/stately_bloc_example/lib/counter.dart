import 'package:equatable/equatable.dart';
import 'package:stately_bloc/stately_bloc.dart';
import 'package:stately_core/stately_core.dart';

class CounterState extends Equatable {
  const CounterState(this.value);

  final int value;

  CounterState copyWith(int value) => CounterState(value);

  List<Object?> get props => [value];
}

sealed class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class CounterBloc extends StatelyGraphBloc<CounterEvent, CounterState> {
  CounterBloc(int value) : super(CounterState(value));

  @override
  StatelyGraph<CounterEvent, CounterState> get graph => StatelyGraph(
        graph: {
          CounterState: {
            IncrementEvent: transition((IncrementEvent event, CounterState state) => state.copyWith(state.value + 1)),
            DecrementEvent: transition((DecrementEvent event, CounterState state) => state.copyWith(state.value - 1)),
          },
        },
      );
}
