import 'package:json_annotation/json_annotation.dart';

base class DownloadExtra {
  @JsonKey(name: "encrypted_media_url")
  final String encryptedMediaUrl;

  DownloadExtra({required this.encryptedMediaUrl});
}
