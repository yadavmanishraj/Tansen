import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';

class ShuffleModeButton extends StatelessWidget {
  const ShuffleModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.read<MusicPlayerBloc>();
    return StreamBuilder<bool>(
      stream: musicBloc.shuffleMode,
      initialData: false,
      builder: (context, snapshot) {
        return IconButton(
          iconSize: 32,
          onPressed: () => {},
          color: !snapshot.data! ? Colors.grey : null,
          icon: const Icon(Icons.shuffle),
        );
      },
    );
  }
}
