import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';
import 'base_model_details.dart';

part 'album.g.dart';

@JsonSerializable()
class Album extends BaseModel {
  @JsonKey(name: "more_info")
  final AlbumExtra? albumExtra;
  Album({
    required super.id,
    required super.title,
    required super.type,
    required super.permaUrl,
    super.explicitContent,
    super.image,
    super.subtitle,
    this.albumExtra,
  });

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}

@JsonSerializable()
class AlbumExtra {
  @JsonKey(name: "release_date")
  final String? releaseDate;
  @JsonKey(name: "song_count")
  final String? songCount;
  @JsonKey(name: "artistMap")
  final ArtistMapped? artists;
  AlbumExtra({
    this.releaseDate,
    this.songCount,
    this.artists,
  });

  factory AlbumExtra.fromJson(Map<String, dynamic> json) =>
      _$AlbumExtraFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumExtraToJson(this);
}
