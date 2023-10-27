import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AppAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late final AudioPlayer _audioPlayer;

  final playlist = ConcatenatingAudioSource(children: []);

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

  init() {
    Rx.combineLatest4(
        _audioPlayer.currentIndexStream,
        queue,
        _audioPlayer.shuffleModeEnabledStream,
        _audioPlayer.shuffleIndicesStream,
        (currentIndex, queue, shuffleModeEnabled, shuffleIndices) {
      final queueIndex =
          getQueueIndex(currentIndex, shuffleModeEnabled, shuffleIndices);
      return (queueIndex != null && queueIndex < queue.length)
          ? queue[queueIndex]
          : null;
    }).whereType<MediaItem>().distinct().listen(mediaItem.add);

    _audioPlayer.playbackEventStream.listen((event) {});
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
}
