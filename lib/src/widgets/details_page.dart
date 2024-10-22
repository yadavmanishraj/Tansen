import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/download/download_bloc.dart';
import 'package:tansen/download/download_progress.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/widgets/art_display.dart';
import 'package:tansen/src/widgets/basics.dart';

class ThemedSubTree extends StatefulWidget {
  const ThemedSubTree(
      {super.key, required this.imageProvider, required this.child});
  final Widget child;
  final ImageProvider? imageProvider;

  @override
  State<ThemedSubTree> createState() => _ThemedSubTreeState();
}

class _ThemedSubTreeState extends State<ThemedSubTree> {
  late final Future<ColorScheme> colorScheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.fromImageProvider(
        brightness: Theme.of(context).brightness,
        provider:
            widget.imageProvider ?? const AssetImage("assets/icons/app.png"));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ColorScheme>(
        future: colorScheme,
        builder: (context, snapshot) {
          return AnimatedTheme(
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceIn,
              data: Theme.of(context).copyWith(colorScheme: snapshot.data),
              child: widget.child);
        });
  }
}

class PlaylistDetailsPage extends StatefulWidget {
  const PlaylistDetailsPage(
      {super.key, required this.albumDetails, this.isOnline = true});

  final Future<DetailsModel?> albumDetails;
  final bool isOnline;

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  final ScrollController scrollController = ScrollController();

  // RewardedAd? _rewardedAd;

  // final adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-1003404641794562/3488070862'
  //     : 'ca-app-pub-3940256099942544/1712485313';

  // void loadAd() {
  //   RewardedAd.load(
  //       adUnitId: adUnitId,
  //       request: const AdRequest(),
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(
  //         // Called when an ad is successfully received.
  //         onAdLoaded: (ad) {
  //           debugPrint('$ad loaded.');
  //           // Keep a reference to the ad so you can show it later.
  //           _rewardedAd = ad;

  //           ad.fullScreenContentCallback = FullScreenContentCallback(
  //               onAdClicked: (e) {},
  //               onAdDismissedFullScreenContent: (ad) {
  //                 ad.dispose();
  //               },
  //               onAdFailedToShowFullScreenContent: (ad, err) {
  //                 ad.dispose();
  //               },
  //               onAdWillDismissFullScreenContent: (e) {});
  //         },
  //         // Called when an ad request failed.
  //         onAdFailedToLoad: (LoadAdError error) {
  //           debugPrint('RewardedAd failed to load: $error');
  //         },
  //       ));
  // }

  @override
  void initState() {
    super.initState();
    albumDetails = widget.albumDetails;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  late final Future<DetailsModel?> albumDetails;

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
              : Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body:
                      CustomScrollView(controller: scrollController, slivers: [
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: IconButton.filledTonal(
                                  style: IconButton.styleFrom(
                                      padding: const EdgeInsets.all(14),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withOpacity(.1)),
                                  onPressed: () {
                                    context
                                        .read<DownloadBloc>()
                                        .songDownloader
                                        .downloadSongs(snapshot.data!.baseModel,
                                            snapshot.data!.mainDetails!);
                                  },
                                  icon:
                                      const Icon(Icons.file_download_outlined)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: IconButton.filledTonal(
                                  style: IconButton.styleFrom(
                                      padding: const EdgeInsets.all(14),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withOpacity(0.1)),
                                  onPressed: () {},
                                  icon: const Icon(Icons.library_add_outlined)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: IconButton.filled(
                                  onPressed: () {
                                    // context.read<MusicPlayerBloc>().add(
                                    //     MusicPlayerAddEvent(
                                    //         baseModel: snapshot
                                    //             .data!.baseModel));

                                    if (widget.isOnline) {
                                      context.read<MusicPlayerBloc>().add(
                                          MusicPlayerAddEvent(
                                              baseModel:
                                                  snapshot.data!.baseModel));
                                    } else {
                                      context.read<MusicPlayerBloc>().add(
                                          MusicPlayerAddEventOffline(
                                              baseModel:
                                                  snapshot.data!.mainDetails!));
                                    }
                                  },
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
                                      padding: const EdgeInsets.all(14),
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
                                      padding: const EdgeInsets.all(14),
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
                                            context.read<DownloadBloc>().add(
                                                  SongDownloadEvent(
                                                    baseModel: snapshot.data!
                                                        .mainDetails![index],
                                                  ),
                                                );
                                            Navigator.pop(context);
                                          },
                                          leading: const Icon(
                                              Icons.download_for_offline),
                                          title: const Text("Downlaod Song"),
                                        )
                                      ],
                                    ),
                                  ));
                        },
                        onTap: () {
                          if (widget.isOnline) {
                            context.read<MusicPlayerBloc>().add(
                                MusicPlayerAddEvent(
                                    index: index,
                                    baseModel: snapshot.data!.baseModel));
                          } else {
                            context.read<MusicPlayerBloc>().add(
                                MusicPlayerAddEventOffline(
                                    index: index,
                                    baseModel: snapshot.data!.mainDetails!));
                          }
                        },
                        leading: AspectRatio(
                          aspectRatio: 1,
                          child: RoundedBox(
                              child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: snapshot
                                        .data?.mainDetails?[index].veryHigh ??
                                    "",
                              ),
                              DownloadTaskIndicator(
                                modelId: snapshot.data!.mainDetails![index].id!,
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
                          snapshot.data?.mainDetails?[index].title ??
                              'no title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: SubTitleAndStatus(
                          modelId: snapshot.data!.mainDetails![index].id!,
                          text: snapshot.data!.mainDetails![index].subText,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: snapshot.data?.detailsMore?.entries.first.value !=
                              null
                          ? ArtContainer(
                              models: snapshot
                                  .data!.detailsMore!.entries.first.value,
                              title: "Artists")
                          : const SizedBox.shrink(),
                    )
                  ]),
                )
          // ),
          ),
    );
  }

  // void downloadAll(BuildContext context, List<BaseModel> songs) {
  //   var downloader = context.read<DownloadBloc>();
  //   for (var element in songs) {
  //     downloader.add(SongDownloadEvent(baseModel: element));
  //   }
  // }
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
                    const Text('songs'),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(height: 45),
                    ),
                    Text(
                      widget.subtitle,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
