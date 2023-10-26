import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
          builder: (context, state) {
        if (state.state.playing &&
            state.state.processingState == ProcessingState.ready) {
          return IconButton(
              onPressed: () {
                context.read<MusicPlayerBloc>().add(MusicPlayerEventPause());
              },
              icon: const Icon(Icons.pause));
        }
        if (!state.state.playing) {
          return IconButton(
              onPressed: () {
                context.read<MusicPlayerBloc>().add(MusicPlayerEventPlay());
              },
              icon: const Icon(Icons.play_arrow));
        }
        return const CircularProgressIndicator(
          strokeWidth: 2,
        );
      }),
    );
  }
}
