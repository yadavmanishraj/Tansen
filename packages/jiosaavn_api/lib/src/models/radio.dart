import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'radio.g.dart';

@JsonSerializable()
class RadioModel extends BaseModel {
  @JsonKey(name: "explicit_content")
  final String? explictContent;
  @JsonKey(name: "mini_obj")
  final bool? miniObject;
  RadioModel({
    required super.id,
    required super.title,
    required super.type,
    required super.permaUrl,
    super.image,
    super.subtitle,
    this.explictContent,
    this.miniObject,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) =>
      _$RadioModelFromJson(json);
  Map<String, dynamic> toJson() => _$RadioModelToJson(this);
}

@JsonSerializable()
class RadioExtra {
  @JsonKey(name: "featured_station_type")
  final String? featuredStationType;
  final String? query;
  @JsonKey(name: "station_display_text")
  final String? stationDisplayText;
  final String? color;
  final String? description;
  final String? language;

  const RadioExtra({
    this.featuredStationType,
    this.query,
    this.stationDisplayText,
    this.color,
    this.description,
    this.language,
  });

  factory RadioExtra.fromJson(Map<String, dynamic> json) =>
      _$RadioExtraFromJson(json);
  Map<String, dynamic> toJson() => _$RadioExtraToJson(this);
}
