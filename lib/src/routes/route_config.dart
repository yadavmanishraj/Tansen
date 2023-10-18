import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tansen/src/features/home/home.dart';
import 'package:tansen/src/routes/view/scaffold_with_navigator.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/",
  routes: [
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, child) => ScaffoldWithNavigator(state: child),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: HomeRoute.route,
              builder: (context, state) => HomeRoute(),
            ),
          ],
        ),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/explore',
            builder: (context, state) => const Text("ExplorePage"),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/library',
            builder: (context, state) => Text("Library Page"),
          ),
        ])
      ],
    )
  ],
  debugLogDiagnostics: true,
);
