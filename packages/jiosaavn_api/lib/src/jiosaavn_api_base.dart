import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:jiosaavn_api/src/models/album_details.dart';
import 'package:jiosaavn_api/src/models/playlist.dart';

import 'endpoints.dart';
import 'models/models.dart';

class JioSaavnApi {
  final http.Client _client;
  JioSaavnApi({http.Client? client}) : _client = client ?? http.Client();

  static const host = "jiosaavn.com";
  static const apiPath = "/api.php";
  static const headers = <String, String>{};
  static const params = {
    "ctx": "web6dot0",
    "api_version": "4",
    "_format": "json",
    "_marker": "0",
  };

  Future _sendRequest(Uri uri) async {
    try {
      final response = await _client.get(uri, headers: headers);
      if (!(response.statusCode == HttpStatus.ok)) {
        throw Exception("Request Failed ${response.statusCode}");
      }

      final jsonBody = await Isolate.run(() => jsonDecode(response.body));
      return jsonBody;
    } catch (e) {
      throw Exception("Someting Went Wrong $e");
    }
  }

  Future<Map<String, List<BaseModel>>> homeData() async {
    var response = await _sendRequest(
            Uri.https(host, apiPath, {"__call": Endpoints.homeData, ...params}))
        as Map;

    final modules = response['modules'];
    response.remove('modules');
    response.remove('history');
    response.remove('global_config');

    return response.map((key, value) {
      value as List;

      return MapEntry<String, List<BaseModel>>(
          modules[key]?['title'] ?? "Discover",
          value.map((e) => BaseModel.fromJson(e)).toList());
    });
  }

  Future _getWebContent(String token, String type,
      [Map<String, String>? restParams]) async {
    final response = await _sendRequest(Uri.http(host, apiPath, {
      ...params,
      ...?restParams,
      "includeMetaTags": "0",
      "__call": Endpoints.webGet,
      "token": token,
      "type": type,
    }));

    return response;
  }

  Future<SongDetails> getSongDetailsByUrl(String url) async {
    final tokens = url.split("/");
    final response = await _getWebContent(tokens.last, ModelType.song) as Map;
    return SongDetails.fromJson((response['songs'] as List).first);
  }

  Future<AlbumDetails> getAlbumDetailsByUrl(String url) async {
    final tokens = url.split("/");
    final response = await _getWebContent(tokens.last, ModelType.album) as Map;
    return AlbumDetails.fromJson(response as Map<String, dynamic>);
  }

  Future<Playlist> getPlaylistDetailsByUrl(String url) async {
    final tokens = url.split("/");
    final response = await _getWebContent(
        tokens.last, ModelType.playlist, {"p": "1", "n": "50"}) as Map;
    return Playlist.fromJson(response as Map<String, dynamic>);
  }

  void close() {
    _client.close();
  }
}
