import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/download/download_bloc.dart';
import 'package:tansen/download/download_progress.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/widgets/art_display.dart';
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

class PlaylistDetailsPage extends StatefulWidget {
  const PlaylistDetailsPage({super.key, required this.albumDetails});

  final Future<DetailsModel?> albumDetails;

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    return Scaffold(
      body: FutureBuilder(
        future: widget.albumDetails,
        builder: (context, snapshot) => !snapshot.hasData
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ThemedSubTree(
                imageProvider:
                    NetworkImage(snapshot.data!.baseModel.image ?? ""),
                child: Builder(builder: (context) {
                  return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    body: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          DetailsHeader(
                              title: snapshot.data?.baseModel.title ?? "",
                              type: snapshot.data?.baseModel.type ?? "song",
                              imageUrl: snapshot.data?.baseModel.veryHigh ?? "",
                              subtitle: snapshot.data?.baseModel.subText ?? "",
                              controller: scrollController),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: IconButton.filledTonal(
                                        style: IconButton.styleFrom(
                                            padding: EdgeInsets.all(14),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary
                                                .withOpacity(0.1)),
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.library_add_outlined)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: IconButton.filled(
                                        onPressed: () {
                                          context.read<MusicPlayerBloc>().add(
                                              MusicPlayerAddEvent(
                                                  baseModel: snapshot
                                                      .data!.baseModel));
                                        },
                                        icon: const Icon(
                                          Icons.play_arrow,
                                          size: 48,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: IconButton.filledTonal(
                                        style: IconButton.styleFrom(
                                            padding: EdgeInsets.all(14),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary
                                                .withOpacity(.1)),
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.ios_share_outlined)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
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
                            itemCount: snapshot.data?.mainDetails?.length ?? 0,
                            itemBuilder: (context, index) => ListTile(
                              onLongPress: () {
                                showModalBottomSheet(
                                    context: context,
                                    useRootNavigator: true,
                                    shape: const RoundedRectangleBorder(),
                                    builder: (context) => Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewPadding
                                                  .bottom),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  context
                                                      .read<DownloadBloc>()
                                                      .add(
                                                        SongDownloadEvent(
                                                          baseModel: snapshot
                                                                  .data!
                                                                  .mainDetails![
                                                              index],
                                                        ),
                                                      );
                                                  Navigator.pop(context);
                                                },
                                                leading: const Icon(
                                                    Icons.download_for_offline),
                                                title:
                                                    const Text("Downlaod Song"),
                                              )
                                            ],
                                          ),
                                        ));
                              },
                              onTap: () {
                                context.read<MusicPlayerBloc>().add(
                                    MusicPlayerAddEvent(
                                        index: index,
                                        baseModel: snapshot.data!.baseModel));
                              },
                              leading: AspectRatio(
                                aspectRatio: 1,
                                child: RoundedBox(
                                    child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data
                                              ?.mainDetails?[index].veryHigh ??
                                          "",
                                    ),
                                    DownloadProgressIndicator(modelId: snapshot
                                              .data!.mainDetails![index].id!)
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
                                snapshot.data?.mainDetails?[index].title ??
                                    'no title',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                  snapshot.data?.mainDetails?[index].subText ??
                                      'no title',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: snapshot.data?.detailsMore?.entries.first
                                        .value !=
                                    null
                                ? ArtContainer(
                                    models: snapshot
                                        .data!.detailsMore!.entries.first.value,
                                    title: "Artists")
                                : const SizedBox.shrink(),
                          )
                        ]),
                  );
                }),
              ),
      ),
    );
  }
}

class DetailsHeader extends StatefulWidget {
  const DetailsHeader({
    super.key,
    required this.title,
    required this.type,
    required this.imageUrl,
    required this.subtitle,
    required this.controller,
  });
  final String title;
  final String type;
  final String imageUrl;
  final String subtitle;
  final ScrollController controller;

  @override
  State<DetailsHeader> createState() => _DetailsHeaderState();
}

class _DetailsHeaderState extends State<DetailsHeader> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  EdgeInsetsGeometry getPadding() {
    if (widget.controller.hasClients &&
        widget.controller.offset >= 458 - kToolbarHeight) {
      return const EdgeInsetsDirectional.only(start: 0, bottom: 16);
    } else {
      return const EdgeInsets.only(bottom: 48);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 458,
      pinned: true,
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: getPadding(),
          title: Text(
            widget.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          collapseMode: CollapseMode.pin,
          background: Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
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
                      Theme.of(context).colorScheme.surface.withOpacity(.3),
                      // Theme.of(context).colorScheme.surface.withOpacity(.9),
                      // Colors.red,
                      // Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).colorScheme.surface.withOpacity(.7),
                      Theme.of(context).colorScheme.surface,
                    ]))),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text('songs'),
                    Text(widget.type.toUpperCase()),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(height: 45),
                    ),
                    Text(
                      widget.subtitle,
                      maxLines: 1,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
