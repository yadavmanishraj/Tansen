import 'package:isar/isar.dart';

part 'song_collection.g.dart';

@collection
class SongCollection {
  Id id = Isar.autoIncrement;
  String? title;
  String? type;
  List<String> songs = [];
  String? imageSrc;
  String? subTitle;

  SongCollection({
    required this.id,
    this.title,
    this.type,
    required this.songs,
    this.imageSrc,
    this.subTitle,
  });
}
