import 'package:jiosaavn_api/src/models/base_model_details.dart';
import 'package:jiosaavn_api/src/models/song_details.dart';
import 'package:json_annotation/json_annotation.dart';

part 'album_details.g.dart';

@JsonSerializable()
class AlbumDetails extends BaseModelDetails {
  final AlbumExtra? albumExtra;
  @JsonKey(name: "list")
  final List<SongDetails>? songs;

  AlbumDetails({
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
    this.albumExtra,
    this.songs,
  });

  factory AlbumDetails.fromJson(Map<String, dynamic> json) =>
      _$AlbumDetailsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AlbumDetailsToJson(this);
}

@JsonSerializable()
class AlbumExtra extends BaseModelDetailsExtra {
  AlbumExtra({
    required super.isDolbyContent,
    super.copyrightText,
    super.labelUrl,
    super.songCount,
  });

  factory AlbumExtra.fromJson(Map<String, dynamic> json) =>
      _$AlbumExtraFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AlbumExtraToJson(this);
}
