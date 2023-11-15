// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) => SearchModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      position: json['position'] as int,
    );

Map<String, dynamic> _$SearchModelToJson(SearchModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'position': instance.position,
    };
