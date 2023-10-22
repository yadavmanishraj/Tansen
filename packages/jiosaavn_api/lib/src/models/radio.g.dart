// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadioModel _$RadioModelFromJson(Map<String, dynamic> json) => RadioModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String? ?? 'unknown',
      permaUrl: json['perma_url'] as String,
      image: json['image'] as String?,
      subtitle: json['subtitle'] as String?,
      explictContent: json['explicit_content'] as String?,
      miniObject: json['mini_obj'] as bool? ?? true,
      radioExtra: json['more_info'] == null
          ? null
          : RadioExtra.fromJson(json['more_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RadioModelToJson(RadioModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'image': instance.image,
      'type': instance.type,
      'perma_url': instance.permaUrl,
      'explicit_content': instance.explictContent,
      'mini_obj': instance.miniObject,
      'more_info': instance.radioExtra,
    };

RadioExtra _$RadioExtraFromJson(Map<String, dynamic> json) => RadioExtra(
      featuredStationType: json['featured_station_type'] as String?,
      query: json['query'] as String?,
      stationDisplayText: json['station_display_text'] as String?,
      color: json['color'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
    );

Map<String, dynamic> _$RadioExtraToJson(RadioExtra instance) =>
    <String, dynamic>{
      'featured_station_type': instance.featuredStationType,
      'query': instance.query,
      'station_display_text': instance.stationDisplayText,
      'color': instance.color,
      'description': instance.description,
      'language': instance.language,
    };
