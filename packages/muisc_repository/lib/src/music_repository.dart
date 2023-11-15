import 'package:jiosaavn_api/jiosaavn_api.dart';
import 'package:muisc_repository/src/models/details_model.dart';

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

  DetailsModel _songParser(SongDetails songDetails) {
    return DetailsModel(baseModel: songDetails, mainDetails: [songDetails]);
  }

  DetailsModel _playlistParser(Playlist playlist) {
    return DetailsModel(
        baseModel: playlist,
        mainDetails: playlist.songs!,
        detailsMore: {"Artists": playlist.playlistExtraDetails?.artists ?? []});
  }

  DetailsModel _albumParser(AlbumDetails albumDetails) {
    final artists = albumDetails.albumExtra?.artists;

    return DetailsModel(
      baseModel: albumDetails,
      mainDetails: albumDetails.songs,
      detailsMore: {"Artists": artists ?? []},
    );
  }

  Future<DetailsModel?> getDetails(
      String type, String id, String permaUrl) async {
    if (type == ModelType.album) {
      return _albumParser(await _jioSaavnApi.getAlbumDetailsByUrl(permaUrl));
    } else if (type == ModelType.song) {
      return _songParser(await _jioSaavnApi.getSongDetailsByUrl(permaUrl));
    } else if (type == ModelType.playlist || type == ModelType.mix) {
      return _playlistParser(
          await _jioSaavnApi.getPlaylistDetailsByUrl(permaUrl));
    }
    return null;
  }

  Future<List<SongDetails>> getDetailsByUrl(
      String permaUrl, String type) async {
    if (type == ModelType.album) {
      final response = await _jioSaavnApi.getAlbumDetailsByUrl(permaUrl);
      return response.songs ?? [];
    } else if (type == ModelType.playlist) {
      final response = await _jioSaavnApi.getPlaylistDetailsByUrl(permaUrl);
      return response.songs ?? [];
    } else if (type == ModelType.song) {
      return [await _jioSaavnApi.getSongDetailsByUrl(permaUrl)];
    }
    return [];
  }

  Future<List<BaseModel>> topSearches() => _jioSaavnApi.getTopSearches();

  Future<List<MapEntry<String, SearchModel>>> search(String query) async {
    final result = await _jioSaavnApi.search(query);
    return result.entries
        .toList()
        .where((element) => element.value.data.isNotEmpty)
        .toList();
  }
}
