import 'package:get_it/get_it.dart';
import 'package:muisc_repository/muisc_repository.dart';

void setUpDependencies() {
  final instance = GetIt.instance;
  instance.registerSingletonAsync(() async => MusicRepository());
}
