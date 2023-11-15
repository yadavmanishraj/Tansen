// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchModelItem _$SearchModelItemFromJson(Map<String, dynamic> json) =>
    SearchModelItem(
      id: json['id'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String? ?? 'unknown',
      permaUrl: json['url'] as String,
    );

Map<String, dynamic> _$SearchModelItemToJson(SearchModelItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'url': instance.permaUrl,
    };
