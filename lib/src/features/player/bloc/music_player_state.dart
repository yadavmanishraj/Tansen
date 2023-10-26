// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'music_player_bloc.dart';

class MusicPlayerState extends Equatable {
  final List<BaseModel> qeue;
  final BaseModel? nowPlaying;
  final PlayerState state;
  final int index;
  final double position;

  const MusicPlayerState(
      {required this.qeue,
      this.nowPlaying,
      required this.state,
      this.index = 0, this.position = 0});

  MusicPlayerState copyWith(
      {List<BaseModel>? qeue,
      BaseModel? nowPlaying,
      PlayerState? state,
      int? index, double? position}) {
    return MusicPlayerState(
        qeue: qeue ?? this.qeue,
        nowPlaying: nowPlaying ?? this.nowPlaying,
        state: state ?? this.state,
        index: index ?? this.index, position: position ?? this.position);
  }

  @override
  List<Object?> get props => [qeue, nowPlaying, nowPlaying, state, index, position];
}
