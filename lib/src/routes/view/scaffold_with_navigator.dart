import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension _ on int {
  String get route {
    if (this == 0) {
      return "/";
    } else if (this == 1)
      return "/explore";
    else
      return "/library";
  }
}

extension on String {
  get index {
    if (this == "/") return 0;
    if (this == "/explore") return 1;
    if (this == "/library")
      return 2;
    else
      return 0;
  }
}

class ScaffoldWithNavigator extends StatefulWidget {
  const ScaffoldWithNavigator({
    super.key,
    required this.state,
  });
  final StatefulNavigationShell state;

  @override
  State<ScaffoldWithNavigator> createState() => _ScaffoldWithNavigatorState();
}

class _ScaffoldWithNavigatorState extends State<ScaffoldWithNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.state,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.state.currentIndex,
        onDestinationSelected: (value) {
          widget.state.goBranch(value, initialLocation: value == 0);
          setState(() {});
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_filled),
              label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: "Explore"),
          NavigationDestination(
              icon: Icon(Icons.library_music_outlined),
              selectedIcon: Icon(Icons.library_music),
              label: "Library"),
        ],
      ),
    );
  }
}
