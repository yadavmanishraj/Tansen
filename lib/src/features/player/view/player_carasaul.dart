import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/widgets/basics.dart';

class PlayerCarasaul extends StatefulWidget {
  const PlayerCarasaul({super.key});

  @override
  State<PlayerCarasaul> createState() => _PlayerCarasaulState();
}

class _PlayerCarasaulState extends State<PlayerCarasaul> {
  late final PageController pageController;
  var system = true;

  @override
  void initState() {
    super.initState();
    // isPlaying = context.read<MusicPlayerBloc>().state.state.playing;
  }

  // @override
  // void didUpdateWidget(covariant PlayerCarasaul oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (pageController.hasClients) {
  //     pageController.jumpToPage(
  //       context.read<MusicPlayerBloc>().state.index,
  //     );
  //   }
  // }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageController = PageController(
        initialPage: context.read<MusicPlayerBloc>().state.index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      listener: (context, state) {
        // log(pageController.page.toString());
        if (system) {
          pageController.jumpToPage(state.index);
        }
        system = true;
      },
      listenWhen: (previous, current) => previous.index != current.index,
      builder: (context, state) {
        return PageView.builder(
          // scrollBehavior: const ScrollBehavior(),
          controller: pageController,
          onPageChanged: (value) {
            if (state.index != value) {
              system = false;
              context
                  .read<MusicPlayerBloc>()
                  .add(MusicPlayerStateSeekIndex(index: value));
            }
          },
          itemCount: state.qeue.length,
          itemBuilder: (context, index) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: RoundedBox(
                radius: 8,
                child:
                    CachedNetworkImage(imageUrl: state.qeue[index].veryHigh!),
              ),
            ),
          ),
        );
      },
    );
  }
}
