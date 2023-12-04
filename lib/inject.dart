import 'package:get_it/get_it.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/download/task_manager.dart';

void setUpDependencies() {
  final instance = GetIt.instance;
  instance.registerSingletonAsync(() async => MusicRepository());
  instance.registerLazySingleton(() => DownloadManager());
}
