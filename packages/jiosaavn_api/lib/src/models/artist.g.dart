// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      id: json['id'] as String?,
      title: json['name'] as String,
      type: json['type'] as String? ?? 'unknown',
      permaUrl: json['perma_url'] as String,
      image: json['image'] as String?,
      subtitle: json['subtitle'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'type': instance.type,
      'perma_url': instance.permaUrl,
      'name': instance.title,
      'role': instance.role,
      'subtitle': instance.subtitle,
    };
