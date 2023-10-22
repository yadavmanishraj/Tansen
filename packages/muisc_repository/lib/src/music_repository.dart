import 'package:jiosaavn_api/jiosaavn_api.dart';

class MusicRepository {
  final JioSaavnApi _jioSaavnApi;

  MusicRepository([JioSaavnApi? jioSaavnApi])
      : _jioSaavnApi = jioSaavnApi ?? JioSaavnApi();

  Future<Map<String, List<BaseModel>>> getHome() async {
    return _jioSaavnApi.homeData();
  }

  Future<List<String>> getDetailsByUrl(String permaUrl, String type) async {
    if (type == ModelType.album) {
      final response = await _jioSaavnApi.getAlbumDetailsByUrl(permaUrl);
      return response.songs
              ?.map((e) => e.veryHigh.downloadUrl ?? "")
              .toList() ??
          [];
    } else if (type == ModelType.playlist) {
      final response = await _jioSaavnApi.getPlaylistDetailsByUrl(permaUrl);
      return response.songs
              ?.map((e) => e.veryHigh.downloadUrl ?? "")
              .toList() ??
          [];
    }
    return [];
  }
}
