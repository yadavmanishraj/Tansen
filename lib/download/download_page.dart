import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/download/download_bloc.dart';
import 'package:tansen/download/download_progress.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/widgets/art_display.dart';
import 'package:tansen/src/widgets/basics.dart';
import 'package:tansen/src/widgets/details_page.dart';

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Downloads",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: DownloadGrid(collections: state.baseModels)),
              ],
            );
          }
        },
      ),
    );
  }
}

class DownloadGrid extends StatelessWidget {
  const DownloadGrid({super.key, required this.collections});
  final List<BaseModel> collections;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: collections.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 167.33 / 205,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8
          // mainAxisSpacing: 16,
          // crossAxisSpacing: 16,
          ),
      itemBuilder: (context, index) => InkWell(
        onTap: () async {
          // context.read<MusicPlayerBloc>().add(
          //     MusicPlayerAddEvent(baseModel: collections.elementAt(index)));

          Future.value(DetailsModel(
                  baseModel: collections[index],
                  mainDetails: await context
                      .read<DownloadBloc>()
                      .getSongs(collections[index])))
              .then((value) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => PlaylistDetailsPage(
                          albumDetails: Future.value(value),
                          isOnline: false,
                        )));
          });

          // context.push(
          //   "/details",
          //   extra: ),
          // );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 167.33,
              width: 167.33,
              child: Center(
                child: ArtDisplay(
                  baseModel: collections.elementAt(index),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    collections.elementAt(index).title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        height: 1, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.check_circle,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        collections.elementAt(index).subText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.5)),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
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
