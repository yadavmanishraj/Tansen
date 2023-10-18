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
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: "Inter",
      ),
      routerConfig: routes,
    );
  }
}
