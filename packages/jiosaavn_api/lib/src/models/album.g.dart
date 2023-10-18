// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      id: json['id'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String? ?? 'unknown',
      permaUrl: json['perma_url'] as String,
      explicitContent: json['explicit_content'] as String?,
      image: json['image'] as String?,
      subtitle: json['subtitle'] as String?,
      albumExtra: json['more_info'] == null
          ? null
          : AlbumExtra.fromJson(json['more_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'image': instance.image,
      'type': instance.type,
      'perma_url': instance.permaUrl,
      'explicit_content': instance.explicitContent,
      'more_info': instance.albumExtra,
    };

AlbumExtra _$AlbumExtraFromJson(Map<String, dynamic> json) => AlbumExtra(
      releaseDate: json['release_date'] as String?,
      songCount: json['song_count'] as String?,
      artists: json['artistMap'] == null
          ? null
          : ArtistMapped.fromJson(json['artistMap'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlbumExtraToJson(AlbumExtra instance) =>
    <String, dynamic>{
      'release_date': instance.releaseDate,
      'song_count': instance.songCount,
      'artistMap': instance.artists,
    };
