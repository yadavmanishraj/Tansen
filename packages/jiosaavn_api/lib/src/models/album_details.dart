import 'package:jiosaavn_api/jiosaavn_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'album_details.g.dart';

@JsonSerializable()
class AlbumDetails extends BaseModelDetails {
  final AlbumDetailsExtra? albumExtra;
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
class AlbumDetailsExtra extends BaseModelDetailsExtra {
  AlbumDetailsExtra({
    required super.isDolbyContent,
    super.copyrightText,
    super.labelUrl,
    super.songCount,
    this.artists,
  });

  final List<BaseModel>? artists;

  factory AlbumDetailsExtra.fromJson(Map<String, dynamic> json) =>
      _$AlbumDetailsExtraFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AlbumDetailsExtraToJson(this);
}
