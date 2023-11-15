import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';

class MusicPorgressBar extends StatelessWidget {
  const MusicPorgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: context.read<MusicPlayerBloc>().state.progress,
      
      initialData: 0,
      builder: (context, state) {
        return SliderTheme(
          data: const SliderThemeData(
              trackHeight: 2,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
          child: Slider.adaptive(
            value: state.data ?? 0,
            onChanged: (value) {
              context.read<MusicPlayerBloc>().add(SeekProgressEvent(value));
            },
          ),
        );
      },
    );
  }
}
