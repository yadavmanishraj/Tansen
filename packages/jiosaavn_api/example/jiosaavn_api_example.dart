import 'package:jiosaavn_api/jiosaavn_api.dart';

void main() async {
  JioSaavnApi api = JioSaavnApi();
  final response = await api.getAlbumDetailsByUrl(
      "https://www.jiosaavn.com/album/kalank/Jv-F,nN0JoY_");
  response.songs?.forEach((element) {
    print(element.songDetailsExtra?.artists?.primaryArtists);
  });
  api.close();
}
