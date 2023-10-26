import 'package:jiosaavn_api/jiosaavn_api.dart';

class MusicRepository {
  final JioSaavnApi _jioSaavnApi;

  MusicRepository([JioSaavnApi? jioSaavnApi])
      : _jioSaavnApi = jioSaavnApi ?? JioSaavnApi();

  Future<Map<String, List<BaseModel>>> getHome() async {
    return _jioSaavnApi.homeData();
  }

  Future<AlbumDetails> getAlbumDetails(String url, String type) async {
    return _jioSaavnApi.getAlbumDetailsByUrl(url);
  }

  Future<List<SongDetails>> getDetailsByUrl(
      String permaUrl, String type) async {
    if (type == ModelType.album) {
      final response = await _jioSaavnApi.getAlbumDetailsByUrl(permaUrl);
      return response.songs ?? [];
    } else if (type == ModelType.playlist) {
      final response = await _jioSaavnApi.getPlaylistDetailsByUrl(permaUrl);
      return response.songs ?? [];
    }
    return [];
  }
}
