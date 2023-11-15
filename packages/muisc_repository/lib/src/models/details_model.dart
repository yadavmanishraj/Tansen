import 'package:muisc_repository/muisc_repository.dart';

class DetailsModel {
  final BaseModel baseModel;
  final List<BaseModel>? mainDetails;
  final Map<String, List<BaseModel>>? detailsMore;

  const DetailsModel({
    this.mainDetails,
    required this.baseModel,
    this.detailsMore,
  });
}
