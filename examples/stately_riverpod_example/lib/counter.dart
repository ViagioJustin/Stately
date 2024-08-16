import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stately_core/stately_core.dart';
import 'package:stately_riverpod/stately_riverpod.dart';

class CounterState extends Equatable {
  const CounterState(this.value);

  final int value;

  CounterState copyWith(int value) => CounterState(value);

  @override
  List<Object?> get props => [value];
}

sealed class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class CounterNotifier extends StatelySyncNotifier<CounterEvent, CounterState> {
  @override
  CounterState build() {
    return CounterState(0);
  }

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

final counterProvider = NotifierProvider<CounterNotifier, CounterState>(() => CounterNotifier());
