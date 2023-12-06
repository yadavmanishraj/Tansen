import 'package:isar/isar.dart';
import 'package:muisc_repository/muisc_repository.dart';

part 'song_collection.g.dart';

@collection
class SongCollection {
  Id id = Isar.autoIncrement;
  String modelId;
  String? title;
  String? type;
  List<String> songs = [];
  String? imageSrc;
  String? subTitle;

  SongCollection({
    required this.modelId,
    this.title,
    this.type,
    required this.songs,
    this.imageSrc,
    this.subTitle,
  });

  BaseModel toBaseModel() => BaseModel(
      id: modelId,
      title: title,
      type: type!,
      permaUrl: imageSrc!,
      subtitle: subTitle,
      image: imageSrc);
}
