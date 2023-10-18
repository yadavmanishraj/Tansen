// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) => SearchModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String? ?? 'unknown',
      description: json['description'] as String?,
      music: json['music'] as String?,
      permaUrl: json['url'] as String,
      position: json['position'] as String?,
      image: json['image'] as String?,
      subtitle: json['subtitle'] as String?,
    );

Map<String, dynamic> _$SearchModelToJson(SearchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'image': instance.image,
      'type': instance.type,
      'description': instance.description,
      'music': instance.music,
      'position': instance.position,
      'url': instance.permaUrl,
    };
