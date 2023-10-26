import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/player/view/play_pause_button.dart';
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
            content: Row(
              children: [
                const Expanded(child: Text("No connection")),
                TextButton(onPressed: () {}, child: const Text("Refresh"))
              ],
            ),
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
          return Scaffold(
            body: HomeDataView(data: data),
            backgroundColor: colorScheme.brightness == Brightness.light
                ? Colors.white.withOpacity(.7)
                : Colors.black.withOpacity(.7),
          );
        }
      },
    );
  }
}

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

    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colorscheme.primaryContainer.withOpacity(.5),
          colorscheme.secondaryContainer.withOpacity(.2),
          colorscheme.tertiaryContainer.withOpacity(.1),
        ],
      )),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            titleSpacing: 0,
            titleTextStyle:
                const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              const PlayPauseButton()
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SvgPicture.asset(
                "assets/icons/icong.svg",
                color: colorscheme.primary,
              ),
            ),
            title: Text(
              "Tansen",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Foxcon",
                  letterSpacing: -1,
                  color: colorscheme.primary),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: ThemedIcon(
                          avatar: Icons.music_note_outlined, label: "Music"),
                    ),
                    ThemedIcon(
                      avatar: Icons.podcasts,
                      label: "Podcasts",
                      selected: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child:
                          ThemedIcon(avatar: Icons.bolt, label: "Audiobooks"),
                    )
                  ],
                ),
              ),
            ),
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
      child: FilterChip.elevated(
          elevation: 0,
          avatar: Icon(
            avatar,
            color: selected
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
          label: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: selected
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          selected: selected,
          selectedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: colorScheme.primary.withOpacity(.2),
          showCheckmark: false,
          onSelected: (v) {}),
    );
  }
}
