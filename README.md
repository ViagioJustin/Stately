# Stately

A simple FSM solution for creating declarative and predictable state machines.

Designed to work with popular state management solutions to no matter what you are using you
should be able to drop this right in!

| stately_core     | [![pub package](https://img.shields.io/pub/v/stately_core.svg?label=stately_core&color=blue)](https://pub.dartlang.org/packages/stately_core)             |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| stately_bloc     | [![pub package](https://img.shields.io/pub/v/stately_bloc.svg?label=stately_bloc&color=blue)](https://pub.dartlang.org/packages/stately_bloc)             |
| stately_notifier | [![pub package](https://img.shields.io/pub/v/stately_notifier.svg?label=stately_notifier&color=blue)](https://pub.dartlang.org/packages/stately_notifier) |
| stately_riverpod | [![pub package](https://img.shields.io/pub/v/stately_riverpod.svg?label=stately_riverpod&color=blue)](https://pub.dartlang.org/packages/stately_riverpod) |

To get started, you can utilize [stately_notifier] without any extra dependencies like so:

```dart
class CounterEvent {
  const CounterEvent(this.value);

  final int value;
}

class CounterValueNotifier extends StatelyChangeNotifier<CounterEvent, int> {
  CounterValueNotifier(super.state);

  @override
  StatelyGraph<CounterEvent, int> get graph => StatelyGraph<ExampleEvent, String>(
        graph: {
          String: {
            ExampleEvent: transition((CounterEvent event, int state) => event.value),
          },
        },
      );
}
```

And then can use it with [ValueListenableBuilder](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html) like so:

```dart
final counter = CounterValueNotifier(0);

/// ...

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: counter,
          builder: (ctx, state, child) {
            return Text(state.toString(), style: Theme.of(context).textTheme.headlineMedium);
          },
        ),
        ElevatedButton(onPressed: () => notifier.add(IncrementEvent()), child: Text('Increment')),
      ],
    );
  }
}
```

That's it!

## Examples

The examples are a great way to see how to utilize this package with a variety of state management solutions.

[stately_notifier]: https://pub.dev/packages/stately_notifier