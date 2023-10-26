import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/home/home.dart';
import 'package:tansen/src/routes/view/scaffold_with_navigator.dart';
import 'package:tansen/src/widgets/details_page.dart';
import 'package:animations/animations.dart';

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
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: "/details",
      pageBuilder: (context, state) => CustomTransitionPage(
        child: PlaylistDetailsPage(
            albumDetails: state.extra as Future<AlbumDetails>),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween =
              Tween(begin: const Offset(1, 1), end: const Offset(0, 0.0))
                  .chain(CurveTween(curve: Curves.easeInSine))
                  .animate(animation);
          return CupertinoPageTransition(
            primaryRouteAnimation: animation,
            secondaryRouteAnimation: secondaryAnimation,
            linearTransition: true,
            child: child,
          );
        },
      ),
    ),
  ],
  debugLogDiagnostics: true,
);
