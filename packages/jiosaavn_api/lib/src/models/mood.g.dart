// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mood _$MoodFromJson(Map<String, dynamic> json) => Mood(
      id: json['id'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String? ?? 'unknown',
      permaUrl: json['perma_url'] as String,
      explictContent: json['explicit_content'] as String?,
      miniObject: json['mini_obj'] as bool? ?? true,
      moodExtra: json['more_info'] == null
          ? null
          : MoodExtra.fromJson(json['more_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MoodToJson(Mood instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'perma_url': instance.permaUrl,
      'explicit_content': instance.explictContent,
      'mini_obj': instance.miniObject,
      'more_info': instance.moodExtra,
    };

MoodExtra _$MoodExtraFromJson(Map<String, dynamic> json) => MoodExtra(
      available: json['available'] as String?,
      badge: json['badge'] as String?,
      isFeatured: json['is_featured'] as String?,
      subType: json['sub_type'] as String?,
      videoThumbnail: json['video_thumbnail'] as String?,
      videoUrl: json['video_url'] as String?,
      tags: (json['tags'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$MoodExtraToJson(MoodExtra instance) => <String, dynamic>{
      'available': instance.available,
      'badge': instance.badge,
      'is_featured': instance.isFeatured,
      'sub_type': instance.subType,
      'video_thumbnail': instance.videoThumbnail,
      'video_url': instance.videoUrl,
      'tags': instance.tags,
    };
