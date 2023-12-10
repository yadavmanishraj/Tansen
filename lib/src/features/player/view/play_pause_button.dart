import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key, this.id = '', this.size = 40});
  final String id;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            builder: (context, state) {
          if (state.state.playing &&
              state.state.processingState == ProcessingState.ready) {
            return IconButton(
                iconSize: size,
                onPressed: () {
                  context.read<MusicPlayerBloc>().add(MusicPlayerEventPause());
                },
                icon: const Icon(Icons.pause));
          } else if (!state.state.playing &&
                  state.state.processingState == ProcessingState.ready ||
              state.state.processingState == ProcessingState.idle) {
            return IconButton(
                iconSize: size,
                onPressed: () {
                  context.read<MusicPlayerBloc>().add(MusicPlayerEventPlay());
                },
                icon: const Icon(Icons.play_arrow));
          } else if ((state.state.playing &&
                  state.state.processingState == ProcessingState.loading) ||
              (!state.state.playing &&
                      state.state.processingState == ProcessingState.loading ||
                  state.state.processingState == ProcessingState.buffering)) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: size,
                width: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                        // iconSize: 32,
                        onPressed: () {
                          context
                              .read<MusicPlayerBloc>()
                              .add(MusicPlayerEventPause());
                        },
                        icon: const Icon(Icons.pause)),
                    const CircularProgressIndicator(strokeWidth: 2)
                  ],
                ),
              ),
            );
          } else if (state.state.processingState == ProcessingState.completed) {
            return IconButton(
                iconSize: size,
                onPressed: () {
                  context
                      .read<MusicPlayerBloc>()
                      .add(const MusicPlayerStateSeekIndex(index: 0));
                },
                icon: const Icon(Icons.refresh));
          }
          return SizedBox(
            height: size,
            width: size,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }),
      ),
    );
  }
}

class PlayPauseButtonWithId extends StatelessWidget {
  const PlayPauseButtonWithId({
    super.key,
    required this.id,
  });
  final String id;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
