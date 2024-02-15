import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/download/download_page.dart';
import 'package:tansen/src/features/home/home.dart';
import 'package:tansen/src/features/search/view/search_view.dart';
import 'package:tansen/src/routes/view/scaffold_with_navigator.dart';
import 'package:tansen/src/widgets/details_page.dart';

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
              builder: (context, state) => const HomeRoute(),
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
            builder: (context, state) => const DownloadPage(),
          ),
        ])
      ],
    ),
    GoRoute(
      path: SearchPage.route,
      // parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => const CupertinoPage(child: SearchPage()),
    ),
    GoRoute(
        // parentNavigatorKey: _rootNavigatorKey,
        path: "/details",
        pageBuilder: (context, state) => CupertinoPage(
            child: PlaylistDetailsPage(
                albumDetails: state.extra as Future<DetailsModel?>))),
  ],
  debugLogDiagnostics: true,
);
