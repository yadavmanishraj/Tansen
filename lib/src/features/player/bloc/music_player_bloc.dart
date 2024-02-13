import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tansen/src/features/player/services/music_handler.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  late final MusicRepository _musicRepository;
  late final AudioPlayer _audioPlayer;
  late final AppAudioHandler appAudioHandler;

  MusicPlayerBloc()
      : super(MusicPlayerState(
            qeue: const [],
            nowPlaying: null,
            state: PlayerState(false, ProcessingState.idle))) {
    appAudioHandler = GetIt.instance.get<AppAudioHandler>();
    _audioPlayer = appAudioHandler.audioPlayer;

    _musicRepository = MusicRepository();
    // _audioPlayer = AudioPlayer();

    _audioPlayer.volumeStream;

    _audioPlayer.playerStateStream.listen(
      (event) {
        // log(event.toString());
        add(MusicPlayerStateChangedEvent(playerState: event));
      },
    );

    initQueIndexed();

    on<MusicPlayerEventPause>((event, emit) async {
      await _audioPlayer.pause();
    });

    on<MusicPlayerStateSeekIndex>(
      (event, emit) async {
        // await changeMusicIndex(event.index);
        log(event.index.toString());
        await _audioPlayer.seek(Duration.zero, index: event.index);
      },
    );

    on<MusicPlayerChangeIndexEvent>((event, emit) {
      // log("${event.index}", name: "Index");
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
    on<MusicPlayerAddEvent>((event, emit) async {
      await _audioPlayer.pause();

      if (state.nowPlaying?.id == event.baseModel.id) {
        add(MusicPlayerStateSeekIndex(index: event.index));
      } else {
        final response = await _musicRepository.getDetailsByUrl(
            event.baseModel.permaUrl, event.baseModel.type);

        emit(state.copyWith(
            qeue: response,
            index: event.index,
            nowPlaying: response[event.index],
            progress: _audioPlayer.positionStream
                .transform(StreamTransformer.fromBind(transformToProgress))));

        // await _audioPlayer.setAudioSource(
        //     ConcatenatingAudioSource(
        //         useLazyPreparation: false,
        //         children: response
        //             .map((e) => ProgressiveAudioSource(
        //                 Uri.parse(e.download.downloadUrl!)))
        //             .toList()),
        //     initialIndex: event.index);

        final items = response
            .map((e) => MediaItem(
                id: e.id!,
                title: e.title!,
                displayTitle: e.title!,
                displaySubtitle: e.songDetailsExtra?.artists?.primaryArtists
                    .map((e) => e.name)
                    .join(", "),
                artUri: Uri.parse(
                  e.image!.replaceAll("150x150", "500x500"),
                ),
                extras: {"url": e.download.downloadUrl}))
            .toList();
        appAudioHandler.loadPlaylistOffline(items, event.index);

        // appAudioHandler.loadPlaylist(
        //     event.baseModel.permaUrl, event.baseModel.type);

        scheduleMicrotask(() async {
          await _audioPlayer.play();

          _audioPlayer.positionStream.listen((event) {
            final duration =
                (_audioPlayer.duration ?? const Duration(seconds: 1))
                    .inMilliseconds;

            final position = event.inMilliseconds;

            final value = position / duration;

            add(MusicPlayerChangePositionEvent(
                value: (value.isNaN || value == double.infinity) ? 0 : value));
          });
          _audioPlayer.currentIndexStream.listen((event) {
            add(MusicPlayerChangeIndexEvent(index: event ?? state.index));
          });
        });
      }
    });

    on<SeekProgressEvent>(_onMusicSeekProgress);

    on<MusicPlayerChangePositionEvent>(
      (event, emit) {
        emit(state.copyWith(position: event.value));
      },
    );

    on<MusicPlayerAddEventOffline>(_onOfflinePlayerCalled);
    on<IndexedQueChangedEvent>(_onIndexedQueueChanged);
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

  FutureOr<void> _onMusicSeekProgress(
      SeekProgressEvent event, Emitter<MusicPlayerState> emit) async {
    final duration = (await _audioPlayer.durationFuture)?.inMilliseconds ?? 0;
    _audioPlayer
        .seek(Duration(milliseconds: (event.progress * duration).toInt()));
  }

  Stream<double> transformToProgress(Stream<Duration> position1) {
    return Rx.combineLatest2(_audioPlayer.durationStream, position1,
        (duration, position) {
      final durationInMill = duration?.inMilliseconds ?? 0.1;
      final postioninMill = position.inMilliseconds;

      final progress = postioninMill / durationInMill;
      // if (progress.isNaN || progress.isInfinite) {
      //   return 0.toDouble();
      // }
      return progress;
    }).where((event) => event <= 1).asBroadcastStream();
  }

  void seekNext() {
    _audioPlayer.seekToNext();
  }

  void seekprevious() {
    _audioPlayer.seekToPrevious();
  }

  FutureOr<void> _onOfflinePlayerCalled(
      MusicPlayerAddEventOffline event, Emitter<MusicPlayerState> emit) async {
    // _audioPlayer.setAudioSource(
    //   ConcatenatingAudioSource(
    //       children: event.baseModel
    //           .map((e) => ProgressiveAudioSource(Uri.file(e.permaUrl)))
    //           .toList()),
    //   initialIndex: event.index,
    // );

    Map<String, String> files = {};

    var d = event.baseModel
        .map((e) async =>
            (await (DefaultCacheManager().getFileFromCache(e.veryHigh!)))!
                .file
                .path)
        .toList();

    for (var i = 0; i < event.baseModel.length; i++) {
      var path = await d[i];
      files.putIfAbsent(event.baseModel[i].veryHigh!, () => path);
    }

    await appAudioHandler.loadPlaylistOffline(
        event.baseModel
            .map(
              (e) => MediaItem(
                id: e.id!,
                title: e.title!,
                displaySubtitle: e.subtitle,
                displayTitle: e.title,
                extras: {"url": e.permaUrl},
                artUri: Uri.file(files[e.veryHigh!]!),
              ),
            )
            .toList(),
        event.index);
    // await _audioPlayer.seek(null, index: event.index);

    emit(state.copyWith(
        qeue: event.baseModel,
        index: event.index,
        nowPlaying: event.baseModel[event.index],
        progress: _audioPlayer.positionStream
            .transform(StreamTransformer.fromBind(transformToProgress))));

    await startPlay();
  }

  Stream<String> get progressDuration => appAudioHandler.progressDuration();
  Stream<String> get totalDurationText => appAudioHandler.totalDurationText();

  Future<void> startPlay() async {
    await _audioPlayer.play();

    _audioPlayer.positionStream.listen((event) {
      final duration =
          (_audioPlayer.duration ?? const Duration(seconds: 1)).inMilliseconds;

      final position = event.inMilliseconds;

      final value = position / duration;

      add(MusicPlayerChangePositionEvent(
          value: (value.isNaN || value == double.infinity) ? 0 : value));
    });
    // _audioPlayer.currentIndexStream.listen((event) {
    //   add(MusicPlayerChangeIndexEvent(index: event ?? state.index));
    // });
  }

  Stream<LoopMode> get loopMode => appAudioHandler.loopMode.distinct();
  Future<void> setLoopMode(LoopMode loopMode) async {
    switch (loopMode) {
      case LoopMode.off:
        appAudioHandler.setRepeatMode(AudioServiceRepeatMode.none);
      case LoopMode.one:
        appAudioHandler.setRepeatMode(AudioServiceRepeatMode.one);
      case LoopMode.all:
        appAudioHandler.setRepeatMode(AudioServiceRepeatMode.all);
    }
  }

  Stream<bool> get shuffleMode => appAudioHandler.shuffleMode;
  Stream<BaseModel?> get nowPlaying =>
      appAudioHandler.mediaItem.map((event) => event?.baseModel);

  Stream<PlayerState> get processingStateStream =>
      _audioPlayer.playerStateStream;

  Future<void> initQueIndexed() async {
    Rx.combineLatest2(appAudioHandler.queue, appAudioHandler.currentIndex,
        (queue, index) {
      add(IndexedQueChangedEvent(
          index: index, queue: queue.map((e) => e.baseModel).toList()));
    });
  }

  FutureOr<void> _onIndexedQueueChanged(
      IndexedQueChangedEvent event, Emitter<MusicPlayerState> emit) {
    emit(state.copyWith(qeue: event.queue, index: event.index));
  }
}

extension on MediaItem {
  BaseModel get baseModel {
    return BaseModel(
        id: id,
        title: title,
        image: artUri.toString(),
        type: "",
        subtitle: displaySubtitle,
        permaUrl: "");
  }
}
