import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/search/view/search_view.dart';
import 'package:tansen/src/widgets/art_display.dart';

import '../home.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});
  static const route = "/";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(GetIt.instance.get()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.homeStatus == HomeStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            action: SnackBarAction(
              label: "Retry",
              onPressed: () {
                context.read<HomeBloc>().add(HomeEventInitial());
              },
            ),
            content: const Text("No Connection"),
          ));
        }
      },
      builder: (context, state) {
        if (state.homeStatus == HomeStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.homeStatus == HomeStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 100,
                  color: colorScheme.error,
                ),
                FilledButton.icon(
                    style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error),
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh"))
              ],
            ),
          );
        } else {
          final data = state.data?.entries;
          return HomeDataView(data: data);
        }
      },
    );
  }
}

final categories = [
  {"label": "Energize", "icon": const Icon(Icons.energy_savings_leaf)}
];

class HomeDataView extends StatefulWidget {
  const HomeDataView({
    super.key,
    required this.data,
  });

  final Iterable<MapEntry<String, List<BaseModel>>>? data;

  @override
  State<HomeDataView> createState() => _HomeDataViewState();
}

class _HomeDataViewState extends State<HomeDataView> {
  ScrollController scrollController = ScrollController();

  var transparent = true;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      // log(scrollController.position.toString());
      if (scrollController.position.pixels ==
              scrollController.position.minScrollExtent &&
          transparent != true) {
        setState(() {
          transparent = true;
        });
      } else if (transparent == true) {
        setState(() {
          transparent = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;
    return GradientMesh(
      scrollController: scrollController,
      // decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      //   colors: [
      //     colorscheme.primaryContainer.withOpacity(.5),
      //     colorscheme.surface,
      //     colorscheme.surface,
      //   ],
      // )),
      image:
          "https://images.unsplash.com/photo-1523821741446-edb2b68bb7a0?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          HomeAppbar(
            colorscheme: colorscheme,
            scrollController: scrollController,
          ),
          CategoryBar(
            scrollController: scrollController,
          ),
          SliverList.builder(
            itemCount: widget.data?.length ?? 0,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ArtContainer(
                title: widget.data!.elementAt(index).key,
                models: widget.data!.elementAt(index).value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeAppbar extends StatefulWidget {
  const HomeAppbar(
      {super.key, required this.colorscheme, required this.scrollController});

  final ColorScheme colorscheme;
  final ScrollController scrollController;

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  final StreamController<double> streamController =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      updatePosition();
    });
  }

  void updatePosition() {
    if (widget.scrollController.hasClients) {
      streamController.add(widget.scrollController.offset);
    }
  }

  double calculateOpacity(double value) {
    if (value > 60) return 1;
    return value / 60;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: streamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return SliverAppBar(
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            backgroundColor: Theme.of(context)
                .colorScheme
                .surface
                .withOpacity(calculateOpacity(snapshot.data!)),
            titleSpacing: 0,
            floating: true,
            titleTextStyle:
                const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            actions: [
              IconButton(
                  onPressed: () {
                    context.push(SearchPage.route);
                  },
                  icon: const Icon(Icons.search)),
              // const PlayPauseButton()
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Badge(
                alignment: Alignment.bottomLeft,
                label: const Text("Preview"),
                backgroundColor: Colors.amber,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/app.png",
                      width: 44,
                    ),
                    ShaderMask(
                      shaderCallback: (rect) => const LinearGradient(colors: [
                        Colors.blueAccent,
                        Colors.purpleAccent,
                        Colors.cyanAccent,
                      ]).createShader(rect),
                      child: const Text(
                        "Tansen",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                          fontSize: 32,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            leadingWidth: 160,
            // leading: Padding(
            //   padding: const EdgeInsets.only(left: 8),
            //   child: Icon(
            //     Icons.music_note_outlined,
            //     size: 44,
            //     color: Theme.of(context).colorScheme.surface,
            //   ),
            // ),
            // title: Badge(
            //   label: const Text("Preview"),
            //   backgroundColor: Colors.amber,
            //   child: Text(
            //     "Music",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontFamily: "Foxcon",
            //       letterSpacing: -1,
            //       color: Theme.of(context).colorScheme.surface,
            //     ),
            //   ),
            // ),
          );
        });
  }
}

class ThemedIcon extends StatelessWidget {
  const ThemedIcon({
    super.key,
    required this.avatar,
    required this.label,
    this.selected = false,
  });

  final String label;
  final IconData avatar;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: AppChip(
        icon: Icon(
          avatar,
          color: selected ? colorScheme.surface : colorScheme.inverseSurface,
        ),
        label: label,
        selected: selected,
      ),
    );
  }
}

class GradientMesh extends StatelessWidget {
  const GradientMesh(
      {super.key,
      required this.image,
      required this.child,
      required this.scrollController});

  final String image;
  final Widget child;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Stack(
      children: [
        PositionedImageBuilder(
          image: image,
          scrollController: scrollController,
        ),
        PositionedGradient(
          scrollController: scrollController,
        ),
        SafeArea(
          bottom: false,
          child: child,
        )
      ],
    );
  }
}

class PositionedGradient extends StatefulWidget {
  const PositionedGradient({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<PositionedGradient> createState() => _PositionedGradientState();
}

class _PositionedGradientState extends State<PositionedGradient> {
  final StreamController<double> streamController =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      updatePosition();
    });
  }

  void updatePosition() {
    if (widget.scrollController.hasClients) {
      streamController.add(widget.scrollController.offset + 30);
    }
  }

  double calculateOpacity(double value) {
    if (value > 60) return 1;
    return value / 60;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: streamController.stream,
        initialData: 30,
        builder: (context, snapshot) {
          return Container(
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context)
                      .colorScheme
                      .surface
                      .withOpacity(calculateOpacity(snapshot.data!)),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          );
        });
  }
}

class PositionedImageBuilder extends StatefulWidget {
  const PositionedImageBuilder(
      {super.key, required this.image, required this.scrollController});
  final String image;
  final ScrollController scrollController;

  @override
  State<PositionedImageBuilder> createState() => _PositionedImageBuilderState();
}

class _PositionedImageBuilderState extends State<PositionedImageBuilder> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      updatePosition();
    });
  }

  void updatePosition() {
    if (widget.scrollController.hasClients) {
      log(widget.scrollController.offset.toString());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: 400,
      child: CachedNetworkImage(
        imageUrl: widget.image,
        fit: BoxFit.cover,
      ),
    );
  }
}

class AppChip extends StatelessWidget {
  const AppChip(
      {super.key,
      required this.icon,
      required this.label,
      this.selected = false});
  final Icon icon;
  final String label;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.15))),
      color: selected
          ? Colors.white
          : Theme.of(context).colorScheme.onSurface.withOpacity(.15),
      borderOnForeground: true,
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Icon(icon.icon,
                    color: selected ? Colors.black : colorScheme.onSurface),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: selected ? Colors.black : colorScheme.onSurface),
                ),
              ],
            )),
      ),
    );
  }
}

class CategoryBar extends StatefulWidget {
  const CategoryBar({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  final StreamController<double> streamController =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      updatePosition();
    });
  }

  void updatePosition() {
    if (widget.scrollController.hasClients) {
      streamController.add(widget.scrollController.offset);
    }
  }

  double calculateOpacity(double value) {
    if (value > 60) return 1;
    return value / 60;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      // floating: true,
      toolbarHeight: 80,
      pinned: true,
      titleSpacing: 0,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<double>(
            stream: streamController.stream,
            initialData: 0,
            builder: (context, snapshot) {
              final opacity = calculateOpacity(snapshot.data!);
              final dividerOpacity = opacity >= .3 ? .3 : opacity;

              return DecoratedBox(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Theme.of(context).colorScheme.outline.withOpacity( dividerOpacity))),
                    color: Theme.of(context)
                    .colorScheme
                    .background
                    .withOpacity(opacity)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: ThemedIcon(
                          avatar: Icons.bolt,
                          label: "Energize",
                          // selected: true,
                        ),
                      ),
                      ThemedIcon(
                        avatar: Icons.auto_awesome,
                        label: "Feel Good",
                      ),
                      ThemedIcon(
                        avatar: Icons.nightlight_sharp,
                        label: "Sleep",
                      ),
                      ThemedIcon(
                        avatar: Icons.center_focus_weak,
                        label: "Focus",
                      ),
                      ThemedIcon(
                        avatar: Icons.commute_sharp,
                        label: "Commute",
                      ),
                      ThemedIcon(
                        avatar: Icons.airline_seat_recline_extra,
                        label: "Relax",
                      ),
                      ThemedIcon(
                        avatar: Icons.auto_awesome_motion,
                        label: "Party",
                      ),
                      ThemedIcon(
                        avatar: Icons.pie_chart_outline_rounded,
                        label: "Romance",
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: ThemedIcon(
                            avatar: Icons.workspaces_outlined,
                            label: "Workout"),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
