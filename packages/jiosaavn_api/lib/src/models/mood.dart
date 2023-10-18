// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'mood.g.dart';

@JsonSerializable()
class Mood extends BaseModel {
  @JsonKey(name: "explicit_content")
  final String? explictContent;
  @JsonKey(name: "mini_obj", defaultValue: true)
  final bool miniObject;
  @JsonKey(name: "more_info")
  final MoodExtra? moodExtra;

  Mood({
    required super.id,
    required super.title,
    required super.type,
    required super.permaUrl,
    this.explictContent,
    required this.miniObject,
    this.moodExtra,
  });
}

@JsonSerializable()
class MoodExtra {
  final String? available;
  final String? badge;
  @JsonKey(name: "is_featured")
  final String? isFeatured;
  @JsonKey(name: "sub_type")
  final String? subType;
  @JsonKey(name: "video_thumbnail")
  final String? videoThumbnail;
  @JsonKey(name: "video_url")
  final String? videoUrl;
  final Map<String, List<String>>? tags;

  MoodExtra({
    this.available,
    this.badge,
    this.isFeatured,
    this.subType,
    this.videoThumbnail,
    this.videoUrl,
    this.tags,
  });

  factory MoodExtra.fromJson(Map<String, dynamic> json) =>
      _$MoodExtraFromJson(json);
  Map<String, dynamic> toJson() => _$MoodExtraToJson(this);
}
