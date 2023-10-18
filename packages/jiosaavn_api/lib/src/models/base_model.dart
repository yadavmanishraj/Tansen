// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'base_model.g.dart';

class ModelType {
  static const radio = "radio_station";
  static const song = "song";
  static const artist = "artist";
  static const album = "album";
  static const playlist = "playlist";
  static const mix = "mix";
  static const channel = "channel";
  static const show = "show";
  static const season = "season";
  static const episode = "episode";
  static const unknown = "unknown";
}

extension on BaseModel {
  String? get veryLow => image?.replaceAll("150x150", "50x50");

  String? get low => image?.replaceAll("150x150", "150x150");

  String? get medium => image?.replaceAll("150x150", "50x50");

  String? get high => image?.replaceAll("150x150", "500x500");
}

@JsonSerializable()
class BaseModel {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? image;
  @JsonKey(defaultValue: ModelType.unknown)
  final String type;
  @JsonKey(name: "perma_url")
  final String permaUrl;

  const BaseModel({
    required this.id,
    required this.title,
    required this.type,
    required this.permaUrl,
    this.subtitle,
    this.image,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);

  @override
  String toString() {
    return 'BaseModel(id: $id, title: $title, subtitle: $subtitle, image: $image, type: $type, permaUrl: $permaUrl)';
  }
}
