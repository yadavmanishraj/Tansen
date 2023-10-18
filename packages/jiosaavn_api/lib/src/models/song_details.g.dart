// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongDetails _$SongDetailsFromJson(Map<String, dynamic> json) => SongDetails(
      id: json['id'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String? ?? 'unknown',
      explicitContent: json['explicit_content'] as String,
      headerDesc: json['header_desc'] as String,
      language: json['language'] as String,
      listCount: json['list_count'] as String,
      listType: json['list_type'] as String,
      playCount: json['play_count'] as String,
      year: json['year'] as String,
      permaUrl: json['perma_url'] as String,
      image: json['image'] as String?,
      subtitle: json['subtitle'] as String?,
      songDetailsExtra: json['more_info'] == null
          ? null
          : SongDetailsExtra.fromJson(
              json['more_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SongDetailsToJson(SongDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'image': instance.image,
      'type': instance.type,
      'perma_url': instance.permaUrl,
      'explicit_content': instance.explicitContent,
      'header_desc': instance.headerDesc,
      'language': instance.language,
      'list_count': instance.listCount,
      'list_type': instance.listType,
      'play_count': instance.playCount,
      'year': instance.year,
      'more_info': instance.songDetailsExtra,
    };

SongDetailsExtra _$SongDetailsExtraFromJson(Map<String, dynamic> json) =>
    SongDetailsExtra(
      maxSupported: json['320kbps'] as String,
      album: json['album'] as String,
      albumId: json['album_id'] as String,
      albumUrl: json['album_url'] as String,
      cacheState: json['cache_state'] as String,
      copyrightText: json['copyright_text'] as String,
      duration: json['duration'] as String,
      encryptedCacheUrl: json['encrypted_cache_url'] as String,
      encryptedMediaUrl: json['encrypted_media_url'] as String,
      hasLyrics: json['has_lyrics'] as String,
      isDolbyContent: json['is_dolby_content'] as bool,
      label: json['label'] as String,
      labelUrl: json['label_url'] as String?,
      lyricsId: json['lyrics_id'] as String?,
      lyricsSnippet: json['lyrics_snippet'] as String?,
      music: json['music'] as String?,
      origin: json['origin'] as String?,
      releaseDate: json['release_date'] as String?,
      requestJiotuneFlag: json['request_jiotune_flag'] as bool? ?? false,
      starred: json['starred'] as String?,
      trillerAvailable: json['triller_available'] as bool? ?? false,
      vcode: json['vcode'] as String?,
      vlink: json['vlink'] as String?,
      webp: json['webp'] as String?,
      artists: json['artistMap'] == null
          ? null
          : ArtistMapped.fromJson(json['artistMap'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SongDetailsExtraToJson(SongDetailsExtra instance) =>
    <String, dynamic>{
      '320kbps': instance.maxSupported,
      'album': instance.album,
      'album_id': instance.albumId,
      'album_url': instance.albumUrl,
      'cache_state': instance.cacheState,
      'copyright_text': instance.copyrightText,
      'duration': instance.duration,
      'encrypted_cache_url': instance.encryptedCacheUrl,
      'encrypted_media_url': instance.encryptedMediaUrl,
      'has_lyrics': instance.hasLyrics,
      'is_dolby_content': instance.isDolbyContent,
      'label': instance.label,
      'label_url': instance.labelUrl,
      'lyrics_id': instance.lyricsId,
      'lyrics_snippet': instance.lyricsSnippet,
      'music': instance.music,
      'origin': instance.origin,
      'release_date': instance.releaseDate,
      'request_jiotune_flag': instance.requestJiotuneFlag,
      'starred': instance.starred,
      'triller_available': instance.trillerAvailable,
      'vcode': instance.vcode,
      'vlink': instance.vlink,
      'webp': instance.webp,
      'artistMap': instance.artists,
    };
