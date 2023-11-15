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
  String get subtitle {
    var char = role!.toLowerCase().codeUnitAt(0) - 32;
    var list = role!.codeUnits.sublist(0, role!.length);
    list.replaceRange(0, 1, [char]);
    return String.fromCharCodes(list);
  }

  Artist({
    required super.id,
    required this.title,
    required super.type,
    required super.permaUrl,
    super.image,
    super.subtitle,
    this.role,
  }) : super(title: title);

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
