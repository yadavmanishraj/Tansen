import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/features/player/view/max_player.dart';
import 'package:tansen/src/widgets/art_display.dart';

import 'play_pause_button.dart';

class MiniPlayerWidget extends StatefulWidget {
  const MiniPlayerWidget({super.key});

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  late final PageController pageController;
  var system = true;

  @override
  void initState() {
    super.initState();
    // isPlaying = context.read<MusicPlayerBloc>().state.state.playing;
  }

  @override
  void didUpdateWidget(covariant MiniPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    log("MIMI Player", name: "MINIPlayer");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageController = PageController(
        initialPage: context.read<MusicPlayerBloc>().state.index);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      listener: (context, state) {
        // log(pageController.page.toString());
        if (system && pageController.hasClients) {
          system = true;
          pageController.jumpToPage(state.index);
        }
        system = true;
      },
      listenWhen: (previous, current) =>
          previous.nowPlaying != current.nowPlaying,
      builder: (context, state) {
        if (state.nowPlaying == null) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          height: 60,
          child: Row(
            children: [
              Expanded(
                  child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  if (value != state.index) {
                    system = false;
                    context
                        .read<MusicPlayerBloc>()
                        .add(MusicPlayerStateSeekIndex(index: value));
                  }
                },
                itemCount: state.qeue.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      useRootNavigator: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      context: context,
                      builder: (context) => MaxPlayer(),
                    );
                  },
                  child: Padding(
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
                ),
              )),
              const PlayPauseButton()
            ],
          ),
        );
      },
    );
  }
}
