import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/widgets/basics.dart';

class ThemedSubTree extends StatelessWidget {
  const ThemedSubTree(
      {super.key, required this.imageProvider, required this.child});
  final Widget child;
  final ImageProvider imageProvider;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ColorScheme>(
        future: ColorScheme.fromImageProvider(
            brightness: Theme.of(context).brightness, provider: imageProvider),
        builder: (context, snapshot) {
          return AnimatedTheme(
              duration: const Duration(milliseconds: 100),
              curve: Curves.bounceIn,
              data: Theme.of(context).copyWith(colorScheme: snapshot.data),
              child: child);
        });
  }
}

class PlaylistDetailsPage extends StatelessWidget {
  const PlaylistDetailsPage({super.key, required this.albumDetails});

  final Future<AlbumDetails> albumDetails;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    return Scaffold(
      body: FutureBuilder(
        future: albumDetails,
        builder: (context, snapshot) => !snapshot.hasData
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ThemedSubTree(
                imageProvider: NetworkImage(snapshot.data?.image ?? ""),
                child: Builder(builder: (context) {
                  return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    body: CustomScrollView(slivers: [
                      SliverAppBar(
                        expandedHeight: 458,
                        pinned: true,
                        actions: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.search))
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              snapshot.data?.title ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            centerTitle: true,
                            collapseMode: CollapseMode.pin,
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                ImageFiltered(
                                  imageFilter:
                                      ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data?.image ?? "",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                        // Theme.of(context)
                                        //     .colorScheme
                                        //     .onPrimary
                                        //     .withOpacity(.1),
                                        Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withOpacity(.3),
                                        // Theme.of(context).colorScheme.surface.withOpacity(.9),
                                        // Colors.red,
                                        // Theme.of(context).scaffoldBackgroundColor,
                                        Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withOpacity(.7),
                                        Theme.of(context).colorScheme.surface,
                                      ]))),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 40),
                                      Text(
                                          '${snapshot.data?.listCount ?? "9"} songs'),
                                      Text(snapshot.data?.type.toUpperCase() ??
                                          "Radio"),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: 300,
                                        width: 300,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data?.image
                                                    ?.replaceAll(
                                                        "150x150", "500x500") ??
                                                "",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: SizedBox(height: 34),
                                      ),
                                      Text(
                                        snapshot.data?.headerDesc ?? "",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: IconButton.filledTonal(
                                    style: IconButton.styleFrom(
                                        padding: EdgeInsets.all(14),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                            .withOpacity(.1)),
                                    onPressed: () {},
                                    icon: const Icon(
                                        Icons.file_download_outlined)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: IconButton.filledTonal(
                                    style: IconButton.styleFrom(
                                        padding: EdgeInsets.all(14),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                            .withOpacity(0.1)),
                                    onPressed: () {},
                                    icon:
                                        const Icon(Icons.library_add_outlined)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: IconButton.filled(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      size: 48,
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: IconButton.filledTonal(
                                    style: IconButton.styleFrom(
                                        padding: EdgeInsets.all(14),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                            .withOpacity(.1)),
                                    onPressed: () {},
                                    icon: const Icon(Icons.ios_share_outlined)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: IconButton.filledTonal(
                                    style: IconButton.styleFrom(
                                        padding: EdgeInsets.all(14),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                            .withOpacity(.1)),
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_vert)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList.builder(
                        itemCount: snapshot.data?.songs?.length ?? 0,
                        itemBuilder: (context, index) => ListTile(
                          leading: AspectRatio(
                            aspectRatio: 1,
                            child: RoundedBox(
                                child: CachedNetworkImage(
                              imageUrl: snapshot.data?.songs
                                      ?.elementAt(index)
                                      .image ??
                                  "",
                            )),
                          ),
                          title: Text(
                              snapshot.data?.songs?.elementAt(index).title ??
                                  'no title'),
                          subtitle: Text(
                              snapshot.data?.songs?.elementAt(index).subText ??
                                  'no title'),
                        ),
                      )
                    ]),
                  );
                }),
              ),
      ),
    );
  }
}
