import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tansen/download/download_bloc.dart';
import 'package:tansen/download/download_model.dart';
import 'package:tansen/download/task_manager.dart';
import 'package:tansen/inject.dart';
import 'package:tansen/player_bloc_observer.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpDependencies();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await Isar.open([DownloadModelSchema],
      directory: (await getApplicationCacheDirectory()).path);
  // Bloc.observer = AppBlocObserverBlocObserver();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MusicPlayerBloc(),
        ),
        BlocProvider(
          create: (context) => DownloadBloc(
              Isar.getInstance()!, GetIt.instance.get<DownloadManager>()),
        )
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.pink[900],
          useMaterial3: true,
          fontFamily: "Foxcon",
        ),
        routerConfig: routes,
      ),
    );
  }
}
