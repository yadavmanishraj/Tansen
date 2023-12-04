import 'package:isar/isar.dart';

part 'download_model.g.dart';

@collection
class DownloadModel {
  Id id = Isar.autoIncrement;

  String? modelId;
  String? title;
  String? type;
  String? subTitle;
  @Index(caseSensitive: false, type: IndexType.value)
  String? taskId;
  String? source;
  String? url;
  String? imageSrc;

  DownloadModel({
    this.modelId,
    this.title,
    this.type,
    this.subTitle,
    this.taskId,
    this.source,
    this.imageSrc,
    this.url,
  });
}
