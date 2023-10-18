import 'package:jiosaavn_api/src/utils/decrpt.dart';

import '../models/models.dart';

class SongQualitiy {
  final String bitrate;
  final String? downloadUrl;
  const SongQualitiy({
    required this.bitrate,
    this.downloadUrl,
  });

  static const qualities = [
    {"id": '_12', "bitrate": '12kbps'},
    {"id": '_48', "bitrate": '48kbps'},
    {"id": '_96', "bitrate": '96kbps'},
    {"id": '_160', "bitrate": '160kbps'},
    {"id": '_320', "bitrate": '320kbps'},
  ];

  @override
  String toString() {
    return downloadUrl ?? "";
  }
}

extension HighQuality on SongDetails {}

extension DownloadExtension on SongDetails {
  String? get downloadUrl =>
      decryptMediaUrl(songDetailsExtra?.encryptedMediaUrl ?? "");

  bool get supportsHighQuality =>
      bool.tryParse(songDetailsExtra?.maxSupported ?? "false") ?? false;

  SongQualitiy get veryLow => SongQualitiy(
      bitrate: "12kbps", downloadUrl: downloadUrl?.replaceAll("_96", "_12"));
  SongQualitiy get low => SongQualitiy(
      bitrate: "48kbps", downloadUrl: downloadUrl?.replaceAll("_96", "_48"));
  SongQualitiy get medium => SongQualitiy(
      bitrate: "96kbps", downloadUrl: downloadUrl?.replaceAll("_96", "_96"));
  SongQualitiy get high => SongQualitiy(
      bitrate: "160kbps", downloadUrl: downloadUrl?.replaceAll("_96", "_160"));
  SongQualitiy get veryHigh => SongQualitiy(
      bitrate: "320kbps",
      downloadUrl:
          supportsHighQuality ? downloadUrl?.replaceAll("_96", "_320") : null);
}
