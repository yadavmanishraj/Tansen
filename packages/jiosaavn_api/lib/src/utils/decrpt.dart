import 'dart:convert';

import 'package:dart_des/dart_des.dart';

String? decryptMediaUrl(String encryptedMediaUrl) {
  try {
    final String key = "38346591";
    final DES desECB = DES(
        key: key.codeUnits,
        mode: DESMode.ECB,
        paddingType: DESPaddingType.PKCS7);
    return String.fromCharCodes(
        desECB.decrypt(base64Decode(encryptedMediaUrl)));
  } catch (e) {
    print(e);
    return null;
  }
}
