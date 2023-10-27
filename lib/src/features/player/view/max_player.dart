import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/features/player/view/player_carasaul.dart';
import 'package:tansen/src/features/player/view/player_progress_view.dart';

class MaxPlayer extends StatelessWidget {
  const MaxPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: 300,
              child: PlayerCarasaul(
                  children: state.qeue
                      .map(
                        (e) => CachedNetworkImage(
                          imageUrl:
                              e.veryHigh!.replaceAll("150x150", "500x500"),
                          fit: BoxFit.cover,
                        ),
                      )
                      .toList()),
            ),
            const PlayerProgressView(),
            Expanded(
              child: ListView.builder(
                itemCount: state.qeue.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(state.qeue.elementAt(index).title!),
                  subtitle: Text(state.qeue.elementAt(index).subText),
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                        imageUrl: state.qeue.elementAt(index).image!),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
