import 'package:jiosaavn_api/jiosaavn_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_model_item.g.dart';

@JsonSerializable()
class SearchModelItem extends BaseModel {
  @override
  @JsonKey(name: "url")
  final String permaUrl;

  const SearchModelItem(
      {required super.id,
      required super.title,
      required super.type,
      required this.permaUrl})
      : super(permaUrl: permaUrl);

  factory SearchModelItem.fromJson(Map<String, dynamic> json) =>
      _$SearchModelItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SearchModelItemToJson(this);
}
