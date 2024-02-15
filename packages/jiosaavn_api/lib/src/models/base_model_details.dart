// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'artist.dart';
import 'base_model.dart';

part 'base_model_details.g.dart';

@JsonSerializable()
class BaseModelDetails extends BaseModel {
  @override
  @JsonKey(name: "explicit_content")
  final String explicitContent;
  @JsonKey(name: "header_desc")
  final String headerDesc;
  final String language;
  @JsonKey(name: "list_count")
  final String listCount;
  @JsonKey(name: "list_type")
  final String listType;
  @JsonKey(name: "play_count")
  final String playCount;
  final String year;

  const BaseModelDetails({
    required super.id,
    required super.title,
    required super.type,
    required this.explicitContent,
    required this.headerDesc,
    required this.language,
    required this.listCount,
    required this.listType,
    required this.playCount,
    required this.year,
    required super.permaUrl,
    super.image,
    super.subtitle,
  });

  factory BaseModelDetails.fromJson(Map<String, dynamic> json) =>
      _$BaseModelDetailsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseModelDetailsToJson(this);
}

@JsonSerializable()
class BaseModelDetailsExtra {
  @JsonKey(name: "copyright_text")
  final String? copyrightText;
  @JsonKey(name: "is_dolby_content", defaultValue: false)
  final bool isDolbyContent;
  @JsonKey(name: "label_url")
  final String? labelUrl;
  @JsonKey(name: "song_count")
  final String? songCount;

  const BaseModelDetailsExtra({
    this.copyrightText,
    required this.isDolbyContent,
    this.labelUrl,
    this.songCount,
  });

  factory BaseModelDetailsExtra.fromJson(Map<String, dynamic> json) =>
      _$BaseModelDetailsExtraFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelDetailsExtraToJson(this);
}

@JsonSerializable()
class ArtistMapped {
  @JsonKey(defaultValue: [])
  final List<Artist> artists;
  @JsonKey(name: "featured_artists", defaultValue: [])
  final List<Artist> featuredArtists;
  @JsonKey(name: "primary_artists", defaultValue: [])
  final List<Artist> primaryArtists;

  const ArtistMapped({
    required this.artists,
    required this.featuredArtists,
    required this.primaryArtists,
  });

  factory ArtistMapped.fromJson(Map<String, dynamic> json) =>
      _$ArtistMappedFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistMappedToJson(this);
}
