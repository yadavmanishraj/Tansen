// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';
import 'package:muisc_repository/muisc_repository.dart';

part 'download_model.g.dart';

@collection
class DownloadModel {
  Id id = Isar.autoIncrement;
  final String? modelId;
  final String? taskId;
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  DownloadModel({
    this.modelId,
    this.taskId,
    this.title,
    this.subtitle,
    this.imageUrl,
  });

  factory DownloadModel.fromBaseModel(BaseModel baseModel, String taskId) {
    return DownloadModel(
      modelId: baseModel.id!,
      taskId: taskId,
      title: baseModel.title ?? "",
      subtitle: baseModel.subText,
      imageUrl: baseModel.veryHigh!,
    );
  }

  BaseModel toBaseModel() => BaseModel(
      id: modelId,
      title: title,
      type: "song",
      permaUrl: imageUrl!,
      image: imageUrl,
      subtitle: subtitle);
}
