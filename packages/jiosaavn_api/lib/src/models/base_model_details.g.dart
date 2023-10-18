// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModelDetails _$BaseModelDetailsFromJson(Map<String, dynamic> json) =>
    BaseModelDetails(
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
    );

Map<String, dynamic> _$BaseModelDetailsToJson(BaseModelDetails instance) =>
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
    };

BaseModelDetailsExtra _$BaseModelDetailsExtraFromJson(
        Map<String, dynamic> json) =>
    BaseModelDetailsExtra(
      copyrightText: json['copyright_text'] as String?,
      isDolbyContent: json['is_dolby_content'] as bool? ?? false,
      labelUrl: json['label_url'] as String?,
      songCount: json['song_count'] as String?,
    );

Map<String, dynamic> _$BaseModelDetailsExtraToJson(
        BaseModelDetailsExtra instance) =>
    <String, dynamic>{
      'copyright_text': instance.copyrightText,
      'is_dolby_content': instance.isDolbyContent,
      'label_url': instance.labelUrl,
      'song_count': instance.songCount,
    };

ArtistMapped _$ArtistMappedFromJson(Map<String, dynamic> json) => ArtistMapped(
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      featuredArtists: (json['featured_artists'] as List<dynamic>?)
              ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      primaryArtists: (json['primary_artists'] as List<dynamic>?)
              ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ArtistMappedToJson(ArtistMapped instance) =>
    <String, dynamic>{
      'artists': instance.artists,
      'featured_artists': instance.featuredArtists,
      'primary_artists': instance.primaryArtists,
    };
