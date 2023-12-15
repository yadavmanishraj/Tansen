import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/main.dart';
import 'package:tansen/src/features/home/view/context_dialog.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/features/player/view/loop_mode.dart';
import 'package:tansen/src/features/player/view/music_progress_bar.dart';
import 'package:tansen/src/features/player/view/play_pause_button.dart';
import 'package:tansen/src/features/player/view/player_carasaul.dart';
import 'package:tansen/src/features/player/view/player_progress_view.dart';
import 'package:tansen/src/features/player/view/shuffle_mode.dart';
import 'package:tansen/src/features/player/view/timer.dart';
import 'package:tansen/src/features/player/view/timer_bottomsheet.dart';
import 'package:tansen/src/widgets/details_page.dart';

class MaxPlayer extends StatelessWidget {
  const MaxPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    fullScreen();
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: const PlayerBackgroundImage(),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: context.pop,
                      icon: const Icon(Icons.expand_more)),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.cast)),
                      IconButton(
                          onPressed: () {
                            // showContextDialog(context, state.data!);
                          },
                          icon: const Icon(Icons.more_vert))
                    ],
                  ))
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 350,
                child: PlayerCarasaul(),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
              child: NowPlayingText(),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: MusicPorgressBar(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: PlayerControls(),
            ),
            const Expanded(child: SizedBox()),
            const PlayerControlsExtra(),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom)
          ],
        )
      ],
    );
  }
}

class NowPlayingText extends StatelessWidget {
  const NowPlayingText({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<MusicPlayerBloc>().nowPlaying,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.data?.title ?? "Not Avialable",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    state.data?.subtitle ?? "Not Avialable",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.favorite_outline))
          ],
        );
      },
    );
  }
}

class PlayerBackgroundImage extends StatelessWidget {
  const PlayerBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) =>
          previous.nowPlaying?.id != current.nowPlaying?.id,
      builder: (context, state) {
        return Container(
          foregroundDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(.5)),
          child: CachedNetworkImage(
            imageUrl: state.nowPlaying!.image!.replaceAll("150x150", "500x500"),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

class PlayerControlsExtra extends StatelessWidget {
  const PlayerControlsExtra({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            iconSize: 32,
            onPressed: () {},
            icon: const Icon(
              Icons.lyrics_outlined,
              color: Colors.grey,
            )),
        const TimerIconButton(),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                enableDrag: true,
                showDragHandle: true,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                context: context,
                builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: const MusicQueueList()),
              );
            },
            icon: const Icon(
              Icons.playlist_play,
              size: 32,
            )),
      ],
    );
  }
}

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ShuffleModeButton(),
        IconButton(
            onPressed: context.read<MusicPlayerBloc>().seekprevious,
            icon: const Icon(Icons.skip_previous),
            iconSize: 38),
        const PlayPauseButton(
          size: 44,
        ),
        IconButton(
          onPressed: context.read<MusicPlayerBloc>().seekNext,
          icon: const Icon(Icons.skip_next),
          iconSize: 38,
        ),
        const LoopModeButton()
      ],
    );
  }
}

class MusicQueueList extends StatelessWidget {
  const MusicQueueList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) => previous.index != current.index,
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.qeue.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              context
                  .read<MusicPlayerBloc>()
                  .add(MusicPlayerStateSeekIndex(index: index));
            },
            title: Text(state.qeue.elementAt(index).title!, maxLines: 1),
            subtitle: Text(state.qeue.elementAt(index).subText, maxLines: 1),
            leading: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                  imageUrl: state.qeue.elementAt(index).image!),
            ),
          ),
        );
      },
    );
  }
}
