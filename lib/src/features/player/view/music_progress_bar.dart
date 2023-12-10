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
          data: SliderThemeData(
              trackHeight: 2,
              inactiveTrackColor: Theme.of(context).colorScheme.inversePrimary,
              trackShape: RectangularSliderTrackShape(),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider.adaptive(
                value: state.data ?? 0,
                onChanged: (value) {
                  context.read<MusicPlayerBloc>().add(SeekProgressEvent(value));
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder(
                      stream: context.read<MusicPlayerBloc>().progressDuration,
                      builder: (context, state) => Text(state.data ?? "00:00"),
                    ),
                    StreamBuilder(
                      stream: context.read<MusicPlayerBloc>().totalDurationText,
                      builder: (context, state) => Text(state.data ?? "00:00"),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
