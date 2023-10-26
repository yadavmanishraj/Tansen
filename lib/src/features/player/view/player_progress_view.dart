import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';

class PlayerProgressView extends StatelessWidget {
  const PlayerProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        return LinearProgressIndicator(
          value: state.position,
          minHeight: 2,
        );
      },
    );
  }
}
