import 'package:jiosaavn_api/jiosaavn_api.dart';

extension SubTitle on BaseModel {
  String get subText {
    if (((subtitle?.trim().isEmpty) ?? true) && type == ModelType.album) {
      return buildAlbumSubtitle(this as Album);
    }
    return subtitle ?? "";
  }
}

String buildAlbumSubtitle(Album album) {
  final artists = album.albumExtra!.artists;
  if (artists == null) {
    return "";
  } else {
    final primaryArtists =
        artists.artists.map((e) => e.name).toList().join(",");
    final sedondaryArtists =
        artists.featuredArtists.map((e) => e.name).toList().join(",");
    final featuredArtists =
        artists.primaryArtists.map((e) => e.name).toList().join(",");

    return "$primaryArtists$sedondaryArtists$featuredArtists";
  }
}
