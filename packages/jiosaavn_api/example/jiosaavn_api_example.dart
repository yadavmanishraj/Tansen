import 'package:jiosaavn_api/jiosaavn_api.dart';

void main() async {
  JioSaavnApi jiosaavn = JioSaavnApi();
  jiosaavn
      .search("romance")
      .then((value) => print(value))
      .then((value) => jiosaavn.close());
}
