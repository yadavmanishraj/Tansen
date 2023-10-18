import 'package:json_annotation/json_annotation.dart';

import 'artist.dart';
import 'base_model_details.dart';
import 'song_details.dart';

part 'playlist.g.dart';

@JsonSerializable()
class Playlist extends BaseModelDetails {
  @JsonKey(name: "list")
  final List<SongDetails>? songs;
  @JsonKey(name: "more_info")
  final PlaylistExtraDetails? playlistExtraDetails;

  Playlist({
    required super.id,
    required super.title,
    required super.type,
    required super.explicitContent,
    required super.headerDesc,
    required super.language,
    required super.listCount,
    required super.listType,
    required super.playCount,
    required super.year,
    required super.permaUrl,
    super.image,
    super.subtitle,
    this.playlistExtraDetails,
    this.songs,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}

@JsonSerializable()
class PlaylistExtraDetails {
  @JsonKey(name: "fan_count")
  final String? fanCount;
  @JsonKey(name: "firstname")
  final String? firstName;
  @JsonKey(name: "follower_count")
  final String? followerCount;
  @JsonKey(name: "isFY", defaultValue: false)
  final bool? isFYP;
  @JsonKey(name: "is_dolby_content", defaultValue: false)
  final bool isDolbyContent;
  @JsonKey(name: "is_followed")
  final String? isFollowed;
  @JsonKey(name: "last_updated")
  final DateTime? lastUpdated;
  final String? lastname;
  @JsonKey(name: "playlist_type")
  final String? playlistType;
  final String? share;
  @JsonKey(name: "subtitle_desc")
  final List<String>? subtitleDesc;
  final String? uid;
  final String? username;
  @JsonKey(name: "video_count")
  final String? videoCount;
  final List<Artist>? artists;

  PlaylistExtraDetails({
    this.fanCount,
    this.firstName,
    this.followerCount,
    this.isFYP,
    required this.isDolbyContent,
    this.isFollowed,
    this.lastUpdated,
    this.lastname,
    this.playlistType,
    this.share,
    this.subtitleDesc,
    this.uid,
    this.username,
    this.artists,
    this.videoCount,
  });

  factory PlaylistExtraDetails.fromJson(Map<String, dynamic> json) =>
      _$PlaylistExtraDetailsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PlaylistExtraDetailsToJson(this);
}
