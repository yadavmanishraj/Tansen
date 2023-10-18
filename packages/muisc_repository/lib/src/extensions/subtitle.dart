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
    final primaryArtists = artists.artists.join(",");
    final sedondaryArtists = artists.featuredArtists.join(",");
    final featuredArtists = artists.primaryArtists.join(",");

    return "$primaryArtists,$sedondaryArtists,$featuredArtists";
  }
}
