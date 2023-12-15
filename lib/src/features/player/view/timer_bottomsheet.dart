import 'package:flutter/material.dart';
import 'package:tansen/src/features/home/view/context_dialog.dart';

Future<void> showSleepTimerDialog(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    builder: (context) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            tileColor: Theme.of(context).colorScheme.secondaryContainer,
            trailing: const PremiumChip(),
            title: const Text(
              "Sleep Timer",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // const TimerCountDown()
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            onTap: () {},
            title: const Text("5 minutes"),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            onTap: () {},
            title: const Text("15 minutes"),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            onTap: () {},
            title: const Text("30 minutes"),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            onTap: () {},
            title: const Text("1 hour"),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            onTap: () {},
            title: const Text("End of track"),
          ),
        ],
      ),
    ),
  );
}

class TimerCountDown extends StatelessWidget {
  const TimerCountDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "03:38",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {},
            label: const Text("Add 5 minutes"),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            child: const Text("Cancel timer"),
          )
        ],
      ),
    );
  }
}
