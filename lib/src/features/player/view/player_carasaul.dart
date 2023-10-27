import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';

class PlayerCarasaul extends StatefulWidget {
  const PlayerCarasaul({super.key, required this.children});
  final List<Widget> children;

  @override
  State<PlayerCarasaul> createState() => _PlayerCarasaulState();
}

class _PlayerCarasaulState extends State<PlayerCarasaul> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // isPlaying = context.read<MusicPlayerBloc>().state.state.playing;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (pageController.hasClients) {
  //      pageController.animateToPage(context.read<MusicPlayerBloc>().state.index,
  //           duration: const Duration(milliseconds: 200),
  //           curve: Curves.bounceIn);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      listener: (context, state) {
        pageController.animateToPage(state.index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceIn);
      },
      listenWhen: (previous, current) => previous.index != current.index,
      builder: (context, state) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (value) {
            context
                .read<MusicPlayerBloc>()
                .add(MusicPlayerStateSeekIndex(index: value));
          },
          itemCount: state.qeue.length,
          itemBuilder: (context, index) => widget.children[index],
        );
      },
    );
  }
}
