import 'package:flutter/material.dart';
import 'package:tansen/src/features/player/view/timer_bottomsheet.dart';

class TimerIconButton extends StatelessWidget {
  const TimerIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 32,
        onPressed: () {
          showSleepTimerDialog(context);
        },
        icon: Badge(
            smallSize: 8,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.timer_outlined)));
  }
}
