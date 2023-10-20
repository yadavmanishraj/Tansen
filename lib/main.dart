import 'package:flutter/material.dart';
import 'package:tansen/inject.dart';
import 'package:tansen/src/routes/routes.dart';

void main() async {
  setUpDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.greenAccent,
        useMaterial3: true,
        fontFamily: "Foxcon",
      ),
      routerConfig: routes,
    );
  }
}
