import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muisc_repository/muisc_repository.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  late final MusicRepository _musicRepository;
  late final AudioPlayer _audioPlayer;

  MusicPlayerBloc()
      : super(MusicPlayerState(
            qeue: const [],
            nowPlaying: null,
            state: PlayerState(false, ProcessingState.idle))) {
    _musicRepository = MusicRepository();
    _audioPlayer = AudioPlayer();

    _audioPlayer.volumeStream;

    _audioPlayer.playerStateStream.listen(
      (event) {
        log(event.toString());
        add(MusicPlayerStateChangedEvent(playerState: event));
      },
    );

    on<MusicPlayerEventPause>((event, emit) async {
      await _audioPlayer.pause();
    });

    on<MusicPlayerStateSeekIndex>(
      (event, emit) async {
        // await changeMusicIndex(event.index);
        await _audioPlayer.seek(Duration.zero, index: event.index);
      },
    );

    on<MusicPlayerChangeIndexEvent>((event, emit) {
      log("${event.index}", name: "Index");
      emit(state.copyWith(
          index: event.index, nowPlaying: state.qeue[event.index]));
    });

    on<MusicPlayerEventPlay>((event, emit) async {
      await _audioPlayer.play();
    });

    on<MusicPlayerStateChangedEvent>(
      (event, emit) {
        emit(state.copyWith(state: event.playerState));
      },
    );
    on<MusicPlayerAddEvent>(
      (event, emit) async {
        await _audioPlayer.pause();

        final response = await _musicRepository.getDetailsByUrl(
            event.baseModel.permaUrl, event.baseModel.type);

        emit(state.copyWith(
            qeue: response, index: 0, nowPlaying: response.first));

        await _audioPlayer.setAudioSource(ConcatenatingAudioSource(
            useLazyPreparation: false,
            children: response
                .map((e) =>
                    ProgressiveAudioSource(Uri.parse(e.download.downloadUrl!)))
                .toList()));

        await _audioPlayer.play();

        _audioPlayer.positionStream.listen((event) {
          final duration = (_audioPlayer.duration ?? const Duration(seconds: 1))
              .inMilliseconds;

          final position = event.inMilliseconds;

          final value = position / duration;

          add(MusicPlayerChangePositionEvent(
              value: (value.isNaN || value == double.infinity) ? 0 : value));
        });
        _audioPlayer.currentIndexStream.listen((event) {
          add(MusicPlayerChangeIndexEvent(index: event ?? state.index));
        });
      },
    );

    on<MusicPlayerChangePositionEvent>(
      (event, emit) {
        emit(state.copyWith(position: event.value));
      },
    );
  }

  changeMusicIndex(int index) async {
    _audioPlayer.seek(Duration.zero, index: index);
    // await _audioPlayer.setAudioSource(
    //     ConcatenatingAudioSource(
    //         useLazyPreparation: false,
    //         children: state.qeue
    //             .map((e) => ProgressiveAudioSource(
    //                 Uri.parse((e as SongDetails).download.downloadUrl!)))
    //             .toList()),
    //     initialIndex: index,
    //     preload: true);

    // await _audioPlayer.play();
  }

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    return super.close();
  }
}
