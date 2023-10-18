import 'base_model_details.dart';

class Episode extends BaseModelDetails {
  const Episode({
    required super.id,
    required super.title,
    required super.type,
    required super.explicitContent,
    required super.headerDesc,
    required super.language,
    required super.listCount,
    required super.listType,
    required super.playCount,
    required super.year,
    required super.permaUrl,
    super.image,
    super.subtitle,
  });
}
