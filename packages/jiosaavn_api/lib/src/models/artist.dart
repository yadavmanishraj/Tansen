import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';
part 'artist.g.dart';

enum ArtistRole {
  starring,
  music,
  singer,
}

@JsonSerializable()
class Artist extends BaseModel {
  @override
  @JsonKey(name: "name")
  final String title;
  final String? role;

  String get name => title;

  Artist({
    required super.id,
    required this.title,
    required super.type,
    required super.permaUrl,
    super.subtitle,
    this.role,
  }) : super(title: title);

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
