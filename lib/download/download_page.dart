import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/download/download_bloc.dart';
import 'package:tansen/download/download_progress.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/widgets/art_display.dart';
import 'package:tansen/src/widgets/basics.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DownloadView();
  }
}

class DownloadView extends StatelessWidget {
  const DownloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<DownloadBloc, DownloadState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return MusicTileList(songs: state.baseModels);
          }
        },
      ),
    );
  }
}

class MusicTileList extends StatelessWidget {
  const MusicTileList({super.key, required this.songs});
  final List<BaseModel> songs;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          context
              .read<MusicPlayerBloc>()
              .add(MusicPlayerAddEventOffline(baseModel: songs, index: index));
        },
        leading: AspectRatio(
          aspectRatio: 1,
          child: RoundedBox(
              child: Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: songs[index].veryHigh!,
              ),
              DownloadTaskIndicator(
                modelId: songs[index].id!,
              )
              // StreamBuilder(
              //   initialData: 0.0,
              //   stream: context
              //       .read<DownloadBloc>()
              //       .progress(snapshot
              //           .data!.mainDetails![index].id!),
              //   builder: (context, snapshot) =>
              //       CircularProgressIndicator(
              //     strokeWidth: 2,
              //     value: snapshot.data != null
              //         ? snapshot.data!
              //         : 0,
              //   ),
              // ),
              // const Icon(Icons.file_download_outlined)
            ],
          )),
        ),
        title: Text(
          songs[index].title ?? 'no title',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: SubTitleAndStatus(
          modelId: songs[index].id!,
          text: songs[index].subText,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }
}
