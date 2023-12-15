// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:rxdart/rxdart.dart';

setupAudioServices() async {
  return await AudioService.init(
      builder: () => AppAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'tansen.music.tansen.music',
        androidNotificationChannelName: 'Music',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ));
}

extension on MediaItem {
  AudioSource get audioSource {
    return ProgressiveAudioSource(Uri.parse(extras!['url']), tag: "");
  }
}

extension on List<MediaItem> {
  List<AudioSource> get audioSources => map((e) => e.audioSource).toList();
}

class AppAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late final AudioPlayer _audioPlayer;

  AudioPlayer get audioPlayer => _audioPlayer;
  final _playlist = ConcatenatingAudioSource(children: []);

  final _mediaQueueIndexed = BehaviorSubject.seeded(CurrentItemQueue());

  AppAudioHandler() {
    _audioPlayer = AudioPlayer();
    init();
  }

  Future<void> setTimer() async {}

  Future<void> _startIndexedQueItemDrama() async {
    Rx.combineLatest2(queue, _audioPlayer.currentIndexStream, (queue, index) {
      return (CurrentItemQueue(queue: queue, index: index ?? 0));
    }).pipe(_mediaQueueIndexed);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    super.addQueueItem(mediaItem);
    _playlist.add(mediaItem.audioSource);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    super.addQueueItems(mediaItems);
    _playlist.addAll(mediaItems.audioSources);
  }

  //TODO Implement this
  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {}

  @override
  Future<void> removeQueueItemAt(int index) async {
    queue.value.removeAt(index);
    _playlist.removeAt(index);
    queue.add(queue.value);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode == AudioServiceShuffleMode.all;

    if (enabled) {
      await _audioPlayer.shuffle();
    }
    playbackState.add(playbackState.value.copyWith(shuffleMode: shuffleMode));

    await _audioPlayer.setShuffleModeEnabled(enabled);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    playbackState.add(playbackState.value.copyWith(repeatMode: repeatMode));
    _audioPlayer.setLoopMode(LoopMode.values[repeatMode.index]);
  }

  Stream<LoopMode> get loopMode => _audioPlayer.loopModeStream;
  Stream<bool> get shuffleMode => _audioPlayer.shuffleModeEnabledStream;

  init() {
    _audioPlayer.setAudioSource(_playlist, preload: false);
    Rx.combineLatest5(
        _audioPlayer.currentIndexStream,
        queue,
        _audioPlayer.shuffleModeEnabledStream,
        _audioPlayer.shuffleIndicesStream,
        _audioPlayer.durationStream,
        (currentIndex, queue, shuffleModeEnabled, shuffleIndices, duration) {
      final queueIndex =
          getQueueIndex(currentIndex, shuffleModeEnabled, shuffleIndices);
      return (queueIndex != null && queueIndex < queue.length)
          ? queue[queueIndex].copyWith(
              duration: duration, rating: const Rating.newHeartRating(true))
          : null;
    }).whereType<MediaItem>().listen((event) {
      mediaItem.add(event);
      ratingStyle.add(RatingStyle.heart);
    });

    // playlist.listen(_audioPlayer.setAudioSource);
    _notifyAudioHandlerAboutPlaybackEvents();

    mediaItem.listen((value) {
      ratingStyle.add(value?.rating?.getRatingStyle() ?? RatingStyle.heart);
    });
  }

  int? getQueueIndex(
      int? currentIndex, bool shuffleModeEnabled, List<int>? shuffleIndices) {
    final effectiveIndex = _audioPlayer.effectiveIndices ?? [];
    final shuffleIndicesInv = List.filled(effectiveIndex.length, 0);

    for (int i = 0; i < effectiveIndex.length; i++) {
      shuffleIndicesInv[effectiveIndex[i]] = i;
    }
    return (shuffleModeEnabled &&
            ((currentIndex ?? 0) < shuffleIndicesInv.length))
        ? shuffleIndicesInv[currentIndex ?? 0]
        : currentIndex;
  }

  @override
  Future<void> play() async {
    if (_audioPlayer.playerState.processingState == ProcessingState.completed) {
      await _audioPlayer.seek(Duration.zero, index: 0);
    } else {
      _audioPlayer.play();
    }
  }

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> skipToNext() => _audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => _audioPlayer.seekToPrevious();

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  @override
  Future<void> skipToQueueItem(int index) =>
      _audioPlayer.seek(Duration.zero, index: index);

  Future<void> loadPlaylistOffline(
    List<MediaItem> mediaItems,
    int index,
  ) async {
    queue.add(mediaItems);
    var sources = mediaItems.map((e) => e.audioSource).toList();
    // playlist.add(ConcatenatingAudioSource(
    //     children: mediaItems.map((e) => e.audioSource).toList()));
    // await audioPlayer.setAudioSource(sources, initialIndex: index);
    await _playlist.clear();
    await _playlist.addAll(sources);
    await _audioPlayer.seek(Duration.zero, index: index);
  }

  // loadPlaylist(String url, String type) async {
  //   final response = await repository.getDetailsByUrl(url, type);
  //   queue.add(response
  //       .map((e) => MediaItem(
  //           id: e.id!,
  //           title: e.title!,
  //           album: e.songDetailsExtra?.album,
  //           displayTitle: e.title,
  //           displaySubtitle: e.subtitle,
  //           artUri: Uri.parse(e.image!.replaceAll("150x150", "500x500"))))
  //       .toList());
  //   playlist.add(ConcatenatingAudioSource(
  //       children: response
  //           .map((e) => ProgressiveAudioSource(Uri.parse(e.downloadUrl!)))
  //           .toList()));
  // }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _audioPlayer.playbackEventStream.listen((event) {
      final playing = !(event.processingState == ProcessingState.completed) &&
          _audioPlayer.playing;

      playbackState.add(playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
          ],
          systemActions: {
            MediaAction.seek,
            MediaAction.setRating,
            MediaAction.setRepeatMode
          },
          androidCompactActionIndices: [
            0,
            1,
            2
          ],
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_audioPlayer.processingState]!,
          playing: playing,
          updatePosition: _audioPlayer.position,
          bufferedPosition: _audioPlayer.bufferedPosition,
          speed: _audioPlayer.speed,
          queueIndex: event.currentIndex,
          repeatMode: AudioServiceRepeatMode.all));
    });
  }

  Stream<int> get currentIndex =>
      _audioPlayer.currentIndexStream.map((event) => event ?? 0);

  Stream<String> progressDuration() {
    return _audioPlayer.positionStream.map((event) => transfrom(event));
  }

  Stream<String> totalDurationText() {
    return _audioPlayer.durationStream
        .map((event) => transfrom(event ?? Duration.zero));
  }

  String transfrom(Duration duration) {
    int seconds = duration.inSeconds;
    int minutes = duration.inMinutes;

    return "${buildHours(minutes)}:${buildHours(seconds)}";
  }

  String buildHours(int duration) {
    duration = duration % 60;

    if (duration <= 0) {
      return "00";
    } else if (duration <= 9) {
      return "0$duration";
    } else {
      return "$duration";
    }
  }
}

class CurrentItemQueue {
  List<MediaItem> queue;
  int index;
  CurrentItemQueue({
    this.queue = const [],
    this.index = 0,
  });
}
