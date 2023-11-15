import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:jiosaavn_api/src/models/album.dart';
import 'package:jiosaavn_api/src/models/album_details.dart';
import 'package:jiosaavn_api/src/models/playlist.dart';
import 'package:jiosaavn_api/src/models/search_model.dart';

import 'endpoints.dart';
import 'models/models.dart';

class JioSaavnApi {
  final http.Client _client;
  JioSaavnApi({http.Client? client}) : _client = client ?? http.Client();

  static const host = "jiosaavn.com";
  static const apiPath = "/api.php";
  static const headers = <String, String>{
    HttpHeaders.cookieHeader:
        "B=7f699e876da3ed6d6db4704ba669a8cb; _ga_BXVL6HHR7F=GS1.1.1689155410.1.1.1689156425.0.0.0; gdpr_acceptance=true; __stripe_mid=75827e95-57bc-43c7-a400-bc77acb540ac5b730c; fbm_126986924002057=base_domain=.jiosaavn.com; _ga_F1NJ1E2HJ2=GS1.1.1696486669.1.0.1696486669.0.0.0; DL=english; CT=NjE5NzIxMTYx; _ga_0S33EMSFSM=GS1.1.1697090021.56.0.1697090021.0.0.0; _ga=GA1.2.898633959.1689155402; L=hindi%2Cenglish%2Cpunjabi; mm_latlong=27.2787%2C85.9514; CH=G03%2CA07%2CO00%2CL03; I=wlVIP8pGrk2C9cppCrzdGntrErW%2FiQXPzXQNW9K3%2B1kiGxtz4HzvNkh7s0XL2KeOAVMqJy2lSVx8HME6NptpjDVVg4RtcvEEI1WBRGzomiQDhCbrOzDLxnY3leNAnEPMwDcaQ%2BqqvcHz3BzOG2UPs0%2BG8sNeoWvt9VYlFZ1hjZ%2FKid%2BFKiUYV3h%2FBfg612wRI%2FEKH%2BIFTA%2FTrit%2Bio9tjZ%2Fcu7BF8Hzbqpj547coRN7Z5BLflAxcRRrN7AKhJM6aFpkHW36HcC6DrzlOuIDwVvXvOEIKdcMxHelVOpcQSRjam904gezzBB6rRaq0Pu8iHRTxnjyFqNY%3D; __stripe_sid=6f3dea70-c58c-433c-b398-f834369068612fa3e4; P=pro%3A1700154433; TID=ZnVsbHByb190aWVy%3A1700154433; geo=103.177.53.238%2CNP%2CBagmati%20Province%2CSindhuli%20Garhi%2C"
  };
  static const params = {
    "ctx": "web6dot0",
    "api_version": "4",
    "_format": "json",
    "_marker": "0",
  };

  static String getToken(String url) {
    return url.split('/').last;
  }

  Future<http.Response> getDetailsByUrl({
    required String token,
    required String type,
    Map params = const {},
    Map headers = const {},
  }) async {
    return _client.get(
      Uri.https(host, apiPath, {
        "__call": "webapi.get",
        "token": token,
        'type': type,
        'p': '1',
        'n': '20',
        ...JioSaavnApi.params,
        ...params,
      }),
      headers: {
        ...JioSaavnApi.headers,
        ...headers,
      },
    );
  }

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
    response.remove('browse_discover');
    response.remove('artist_recos');
    response.remove('radio');

    return response.map((key, value) {
      value as List;

      return MapEntry<String, List<BaseModel>>(
          modules[key]?['title'] ?? "Discover",
          value.map((e) {
            final type = e['type'];
            if (type == ModelType.album) {
              return Album.fromJson(e);
            } else if (type == ModelType.radio) {
              return RadioModel.fromJson(e);
            } else {
              return BaseModel.fromJson(e);
            }
          }).toList());
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

  Future<List<BaseModel>> getTopSearches() async {
    final response = await _sendRequest(Uri.http(host, apiPath, {
      ...params,
      "__call": Endpoints.topSearches,
    })) as List;

    return response.map((e) => BaseModel.fromJson(e)).toList();
  }

  getArtistDetails(
    String permaUrl, {
    int p = 0,
    int songCount = 50,
    int albumCount = 50,
    String? category,
    String? sortOrder,
    String? subCategory,
    bool? more,
  }) {}

  void close() {
    _client.close();
  }

  Future<Map<String, SearchModel>> search(String query) async {
    final response = await _client.get(
        Uri.https(host, apiPath,
            {...params, "__call": Endpoints.search, "query": query}),
        headers: headers);

    final jsonResponse = jsonDecode(response.body) as Map;
    print(jsonResponse);
    return jsonResponse
        .map((key, value) => MapEntry(key, SearchModel.fromJson(value)));
  }
}
