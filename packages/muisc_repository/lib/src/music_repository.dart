import 'package:jiosaavn_api/jiosaavn_api.dart';

class MusicRepository {
  final JioSaavnApi _jioSaavnApi;

  MusicRepository([JioSaavnApi? jioSaavnApi])
      : _jioSaavnApi = jioSaavnApi ?? JioSaavnApi();

  Future<Map<String, List<BaseModel>>> getHome() async {
    return _jioSaavnApi.homeData();
  }
}
