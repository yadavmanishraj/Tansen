import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tansen/inject.dart';
import 'package:tansen/player_bloc_observer.dart';
import 'package:tansen/src/features/player/bloc/music_player_bloc.dart';
import 'package:tansen/src/routes/routes.dart';

void main() async {
  setUpDependencies();
  Bloc.observer = AppBlocObserverBlocObserver();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicPlayerBloc(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.red,
          useMaterial3: true,
          fontFamily: "Foxcon",
        ),
        routerConfig: routes,
      ),
    );
  }
}
