import 'package:jiosaavn_api/src/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

@JsonSerializable()
class SearchModel extends BaseModel {
  final String? description;
  final String? music;
  final String? position;
  @override
  @JsonKey(name: "url")
  final String permaUrl;

  SearchModel({
    required super.id,
    required super.title,
    required super.type,
    this.description,
    this.music,
    required this.permaUrl,
    this.position,
    super.image,
    super.subtitle,
  }) : super(permaUrl: permaUrl);

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SearchModelToJson(this);
}
