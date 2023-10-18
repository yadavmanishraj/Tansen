import 'base_model.dart';

class Chart extends BaseModel {
  Chart({
    required super.id,
    required super.title,
    required super.type,
    required super.permaUrl,
    super.image,
    super.subtitle,
  });
}
