import 'package:get_it/get_it.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/download/task_manager.dart';
import 'package:tansen/src/features/player/services/music_handler.dart';

Future<void> setUpDependencies() async {
  final instance = GetIt.instance;
  instance.registerSingletonAsync(() async => MusicRepository());
  instance.registerLazySingleton(() => DownloadManager());
  instance.registerSingleton<AppAudioHandler>(await setupAudioServices());
}
