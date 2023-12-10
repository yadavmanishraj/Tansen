import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tansen/download/download_bloc.dart';
import 'package:tansen/download/download_model.dart';
import 'package:tansen/download/song_collection.dart';
import 'package:tansen/download/task_manager.dart';
import 'package:tansen/inject.dart';
import 'package:tansen/player_bloc_observer.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/routes/routes.dart';

Future<void> fullScreen() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    statusBarColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  fullScreen();
  await setUpDependencies();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await Isar.open([DownloadModelSchema, SongCollectionSchema],
      directory: (await getApplicationCacheDirectory()).path);
  // Bloc.observer = AppBlocObserverBlocObserver();
  // await MobileAds.instance.initialize();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App>{
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    GetIt.I.get<DownloadManager>().bind();
  }

  @override
  Widget build(BuildContext context) {
    fullScreen();
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

  @override
  void dispose() {
    GetIt.I.get<DownloadManager>().dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
