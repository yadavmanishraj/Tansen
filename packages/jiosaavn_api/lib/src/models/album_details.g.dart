// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumDetails _$AlbumDetailsFromJson(Map<String, dynamic> json) => AlbumDetails(
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
      albumExtra: json['albumExtra'] == null
          ? null
          : AlbumDetailsExtra.fromJson(
              json['albumExtra'] as Map<String, dynamic>),
      songs: (json['list'] as List<dynamic>?)
          ?.map((e) => SongDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AlbumDetailsToJson(AlbumDetails instance) =>
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
      'albumExtra': instance.albumExtra,
      'list': instance.songs,
    };

AlbumDetailsExtra _$AlbumDetailsExtraFromJson(Map<String, dynamic> json) =>
    AlbumDetailsExtra(
      isDolbyContent: json['is_dolby_content'] as bool? ?? false,
      copyrightText: json['copyright_text'] as String?,
      labelUrl: json['label_url'] as String?,
      songCount: json['song_count'] as String?,
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AlbumDetailsExtraToJson(AlbumDetailsExtra instance) =>
    <String, dynamic>{
      'copyright_text': instance.copyrightText,
      'is_dolby_content': instance.isDolbyContent,
      'label_url': instance.labelUrl,
      'song_count': instance.songCount,
      'artists': instance.artists,
    };
