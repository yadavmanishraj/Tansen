import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';

extension on LoopMode {
  IconData get icon {
    switch (this) {
      case LoopMode.all:
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
    }
  }
}

class LoopModeButton extends StatelessWidget {
  const LoopModeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.read<MusicPlayerBloc>();
    return StreamBuilder<LoopMode>(
        stream: musicBloc.loopMode,
        initialData: LoopMode.off,
        builder: (context, snapshot) {
          return IconButton(
            iconSize: 32,
            onPressed: () => _action(context, snapshot.data!),
            color: snapshot.data! == LoopMode.off ? Colors.grey : null,
            icon: Icon(snapshot.data!.icon),
          );
        });
  }

  _action(BuildContext context, LoopMode loopMode) {
    LoopMode loopMode0 = LoopMode.off;
    if (loopMode == LoopMode.all) {
      loopMode0 = LoopMode.one;
    } else if (loopMode == LoopMode.one) {
      loopMode0 = LoopMode.off;
    } else if (loopMode == LoopMode.off) {
      loopMode0 = LoopMode.all;
    }

    context.read<MusicPlayerBloc>().setLoopMode(loopMode0);
  }
}
