import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedStatefulShellRoute<HomeScreenRouteData>(
  branches: [
    TypedStatefulShellBranch<OverviewPageBranchData>(
      routes: [
        TypedGoRoute<OverviewPageRouteData>(
          name: 'overview',
          path: '/overview',
        ),
      ],
    ),
    TypedStatefulShellBranch<MusicPageBranchData>(
      routes: [
        TypedGoRoute<MusicPlayerPageRouteData>(
          name: 'music',
          path: '/music',
        ),
      ],
    ),
  ],
)
@immutable
class HomeScreenRouteData extends StatefulShellRouteData {
  const HomeScreenRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) =>
      navigationShell;

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return AirplaneEntertainmentSystemScreen(
      navigationShell: navigationShell,
      children: children,
    );
  }
}

@immutable
class OverviewPageBranchData extends StatefulShellBranchData {
  const OverviewPageBranchData();
}

@immutable
class OverviewPageRouteData extends GoRouteData {
  const OverviewPageRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OverviewPage();
}

@immutable
class MusicPageBranchData extends StatefulShellBranchData {
  const MusicPageBranchData();
}

@immutable
class MusicPlayerPageRouteData extends GoRouteData {
  const MusicPlayerPageRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MusicPlayerPage();
}
