// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'music_player_bloc.dart';

sealed class MusicPlayerEvent extends Equatable {
  const MusicPlayerEvent();

  @override
  List<Object> get props => [];
}

class MusicPlayerEventPause extends MusicPlayerEvent {}

class MusicPlayerEventPlay extends MusicPlayerEvent {}

class MusicPlayerStateChangedEvent extends MusicPlayerEvent {
  final PlayerState playerState;
  const MusicPlayerStateChangedEvent({
    required this.playerState,
  });
}

class MusicPlayerChangeIndexEvent extends MusicPlayerEvent {
  final int index;
  const MusicPlayerChangeIndexEvent({
    required this.index,
  });

  @override
  List<Object> get props => [super.props, index];
}

class MusicPlayerStateSeekIndex extends MusicPlayerEvent {
  final int index;
  const MusicPlayerStateSeekIndex({
    required this.index,
  });

  @override
  List<Object> get props => [super.props, index];
}

class MusicPlayerChangePositionEvent extends MusicPlayerEvent {
  final double value;
  const MusicPlayerChangePositionEvent({
    required this.value,
  });
}

class MusicPlayerAddEvent extends MusicPlayerEvent {
  final BaseModel baseModel;
  final int index;
  const MusicPlayerAddEvent({
    required this.baseModel,
    this.index = 0,
  });

  @override
  List<Object> get props => [baseModel, index];
}

class SeekProgressEvent extends MusicPlayerEvent {
  final double progress;
  const SeekProgressEvent(this.progress);

  @override
  List<Object> get props => [progress];
}
