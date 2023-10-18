// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'base_model_details.dart';

part 'song_details.g.dart';

@JsonSerializable()
class SongDetails extends BaseModelDetails {
  @JsonKey(name: "more_info")
  final SongDetailsExtra? songDetailsExtra;

  SongDetails({
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
    this.songDetailsExtra,
  });

  factory SongDetails.fromJson(Map<String, dynamic> json) =>
      _$SongDetailsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SongDetailsToJson(this);

  @override
  String toString() => 'SongDetails(songDetailsExtra: $songDetailsExtra)';
}

@JsonSerializable()
class SongDetailsExtra {
  @JsonKey(name: "320kbps")
  final String maxSupported;
  final String album;
  @JsonKey(name: "album_id")
  final String albumId;
  @JsonKey(name: "album_url")
  final String albumUrl;
  @JsonKey(name: "cache_state")
  final String cacheState;
  @JsonKey(name: "copyright_text")
  final String copyrightText;
  final String duration;
  @JsonKey(name: "encrypted_cache_url")
  final String encryptedCacheUrl;
  @JsonKey(name: "encrypted_media_url")
  final String encryptedMediaUrl;
  @JsonKey(name: "has_lyrics")
  final String hasLyrics;
  @JsonKey(name: "is_dolby_content")
  final bool isDolbyContent;
  final String label;
  @JsonKey(name: "label_url")
  final String? labelUrl;
  @JsonKey(name: "lyrics_id")
  final String? lyricsId;
  @JsonKey(name: "lyrics_snippet")
  final String? lyricsSnippet;
  final String? music;
  final String? origin;
  @JsonKey(name: "release_date")
  final String? releaseDate;
  @JsonKey(name: "request_jiotune_flag", defaultValue: false)
  final bool requestJiotuneFlag;
  final String? starred;
  @JsonKey(name: "triller_available", defaultValue: false)
  final bool trillerAvailable;
  final String? vcode;
  final String? vlink;
  final String? webp;
  @JsonKey(name: "artistMap")
  final ArtistMapped? artists;
  SongDetailsExtra({
    required this.maxSupported,
    required this.album,
    required this.albumId,
    required this.albumUrl,
    required this.cacheState,
    required this.copyrightText,
    required this.duration,
    required this.encryptedCacheUrl,
    required this.encryptedMediaUrl,
    required this.hasLyrics,
    required this.isDolbyContent,
    required this.label,
    required this.labelUrl,
    required this.lyricsId,
    required this.lyricsSnippet,
    required this.music,
    required this.origin,
    required this.releaseDate,
    required this.requestJiotuneFlag,
    required this.starred,
    required this.trillerAvailable,
    required this.vcode,
    required this.vlink,
    required this.webp,
    this.artists,
  });

  factory SongDetailsExtra.fromJson(Map<String, dynamic> json) =>
      _$SongDetailsExtraFromJson(json);

  Map<String, dynamic> toJson() => _$SongDetailsExtraToJson(this);

  @override
  String toString() {
    return 'SongDetailsExtra(maxSupported: $maxSupported, album: $album, albumId: $albumId, albumUrl: $albumUrl, cacheState: $cacheState, copyrightText: $copyrightText, duration: $duration, encryptedCacheUrl: $encryptedCacheUrl, encryptedMediaUrl: $encryptedMediaUrl, hasLyrics: $hasLyrics, isDolbyContent: $isDolbyContent, label: $label, labelUrl: $labelUrl, lyricsId: $lyricsId, lyricsSnippet: $lyricsSnippet, music: $music, origin: $origin, releaseDate: $releaseDate, requestJiotuneFlag: $requestJiotuneFlag, starred: $starred, trillerAvailable: $trillerAvailable, vcode: $vcode, vlink: $vlink, webp: $webp, artists: $artists)';
  }
}
