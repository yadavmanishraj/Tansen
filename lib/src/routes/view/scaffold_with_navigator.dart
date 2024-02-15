import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tansen/main.dart';
import 'package:tansen/src/features/player/view/mini_player_widget.dart';
import 'package:tansen/src/features/player/view/player_progress_view.dart';

extension _ on int {
  String get route {
    if (this == 0) {
      return "/";
    } else if (this == 1)
      return "/explore";
    else
      return "/library";
  }
}

extension on String {
  get index {
    if (this == "/") return 0;
    if (this == "/explore") return 1;
    if (this == "/library") {
      return 2;
    } else {
      return 0;
    }
  }
}

class ScaffoldWithNavigator extends StatefulWidget {
  const ScaffoldWithNavigator({
    super.key,
    required this.state,
  });
  final StatefulNavigationShell state;

  @override
  State<ScaffoldWithNavigator> createState() => _ScaffoldWithNavigatorState();
}

class _ScaffoldWithNavigatorState extends State<ScaffoldWithNavigator> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    fullScreen();
    return Scaffold(
      body: widget.state,
      extendBody: true,
      bottomNavigationBar: Material(
        elevation: 10,
        color: Colors.transparent,
        // shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.background.withOpacity(.4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MiniPlayerWidget(),
                  const PlayerProgressView(),
                  const SizedBox(height: 16),
                  NavigationBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    selectedIndex: widget.state.currentIndex,
                    onDestinationSelected: (value) {
                      widget.state.goBranch(value, initialLocation: value == widget.state.currentIndex);
                      setState(() {});
                    },
                    height: 50,
                    destinations: const [
                      NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home_filled),
                          label: "Home"),
                      NavigationDestination(
                          icon: Icon(Icons.explore_outlined),
                          selectedIcon: Icon(Icons.explore),
                          label: "Explore"),
                      NavigationDestination(
                          icon: Icon(Icons.library_music_outlined),
                          selectedIcon: Icon(Icons.library_music),
                          label: "Library"),
                    ],
                  ),
                  // const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class MiniPlayerWidget extends StatefulWidget {
//   const MiniPlayerWidget({super.key});

//   @override
//   State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
// }

// class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
//   late final PageController pageController;
//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController();
//   }

//   @override
//   void didUpdateWidget(covariant MiniPlayerWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     pageController.animateToPage(context.read<MusicPlayerBloc>().state.index,
//         duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     pageController.animateToPage(context.read<MusicPlayerBloc>().state.index,
//         duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//               child: BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
//             listener: (context, state) {
//               pageController.jumpToPage(state.index);
//             },
//             listenWhen: (previous, current) => previous.index != current.index,
//             builder: (context, state) {
//               return PageView.builder(
//                 controller: pageController,
//                 onPageChanged: (value) {
//                   context
//                       .read<MusicPlayerBloc>()
//                       .add(MusicPlayerStateChangeIndex(index: value));
//                 },
//                 itemCount: state.qeue.length,
//                 itemBuilder: (context, index) => Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Row(
//                     children: [
//                       AspectRatio(
//                           aspectRatio: 1 / 1,
//                           child: ArtDisplay(baseModel: state.qeue[index])),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               state.qeue[index].title!,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               state.qeue[index].subText,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           )),
//           const PlayPauseButton()
//         ],
//       ),
//     );
//   }
// }
