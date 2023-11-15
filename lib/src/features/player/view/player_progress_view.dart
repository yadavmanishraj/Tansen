import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';

class PlayerProgressView extends StatelessWidget {
  const PlayerProgressView({super.key, this.hidden = false});
  final bool hidden;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) => previous.progress != current.progress,
      builder: (context, state) {
        return StreamBuilder<double>(
          stream: state.progress,
          initialData: 0,
          builder: (context, state) {
            return LinearProgressIndicator(
              value: state.data?.toDouble() ?? 0,
              minHeight: 2,
            );
          },
        );
      },
    );
  }
}
