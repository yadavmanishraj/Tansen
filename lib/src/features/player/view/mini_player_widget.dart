import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/widgets/art_display.dart';

import 'play_pause_button.dart';

class MiniPlayerWidget extends StatefulWidget {
  const MiniPlayerWidget({super.key});

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // isPlaying = context.read<MusicPlayerBloc>().state.state.playing;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
              child: BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
            listener: (context, state) {
              pageController.animateToPage(state.index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceIn);
            },
            listenWhen: (previous, current) => previous.index != current.index,
            builder: (context, state) {
              return PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  context
                      .read<MusicPlayerBloc>()
                      .add(MusicPlayerStateSeekIndex(index: value));
                },
                itemCount: state.qeue.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ArtDisplay(baseModel: state.qeue[index])),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.qeue[index].title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              state.qeue[index].subText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
          const PlayPauseButton()
        ],
      ),
    );
  }
}
