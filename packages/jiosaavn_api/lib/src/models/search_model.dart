import 'package:jiosaavn_api/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

@JsonSerializable()
class SearchModel {
  final List<BaseModel> data;
  final int position;
  SearchModel({
    required this.data,
    required this.position,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchModelToJson(this);

  @override
  String toString() => 'SearchModel(data: $data, position: $position)';
}
