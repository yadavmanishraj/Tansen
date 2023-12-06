import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/features/player/view/music_progress_bar.dart';
import 'package:tansen/src/features/player/view/play_pause_button.dart';
import 'package:tansen/src/features/player/view/player_carasaul.dart';
import 'package:tansen/src/features/player/view/player_progress_view.dart';

class MaxPlayer extends StatelessWidget {
  const MaxPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: const PlayerBackgroundImage(),
          ),
        ),
        const Column(
          children: [
            SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 400,
              child: PlayerCarasaul(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: NowPlayingText(),
            ),
            MusicPorgressBar(),
            PlayerControls(),
            PlayerControlsExtra()
          ],
        ),
      ],
    );
  }
}

class NowPlayingText extends StatelessWidget {
  const NowPlayingText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.nowPlaying?.title ?? "Not Avialable",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    state.nowPlaying?.subText ?? "Not Avialable",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            )
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
            onPressed: () {},
            icon: const Icon(
              Icons.lyrics_outlined,
              color: Colors.grey,
            )),
        const IconButton(onPressed: null, icon: Icon(Icons.cast)),
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
                    child: MusicQueueList()),
              );
            },
            icon: const Icon(Icons.list)),
      ],
    );
  }
}

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
        IconButton(
            onPressed: context.read<MusicPlayerBloc>().seekprevious,
            icon: const Icon(Icons.skip_previous)),
        const PlayPauseButton(
          size: 40,
        ),
        IconButton(
            onPressed: context.read<MusicPlayerBloc>().seekNext,
            icon: const Icon(Icons.skip_next)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.repeat))
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
