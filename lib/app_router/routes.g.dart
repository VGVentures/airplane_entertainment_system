// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeScreenRouteData];

RouteBase get $homeScreenRouteData => StatefulShellRouteData.$route(
  navigatorContainerBuilder: HomeScreenRouteData.$navigatorContainerBuilder,
  factory: $HomeScreenRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/overview',
          name: 'overview',
          factory: $OverviewPageRouteData._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/music',
          name: 'music',
          factory: $MusicPlayerPageRouteData._fromState,
        ),
      ],
    ),
  ],
);

extension $HomeScreenRouteDataExtension on HomeScreenRouteData {
  static HomeScreenRouteData _fromState(GoRouterState state) =>
      const HomeScreenRouteData();
}

mixin $OverviewPageRouteData on GoRouteData {
  static OverviewPageRouteData _fromState(GoRouterState state) =>
      const OverviewPageRouteData();

  @override
  String get location => GoRouteData.$location('/overview');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MusicPlayerPageRouteData on GoRouteData {
  static MusicPlayerPageRouteData _fromState(GoRouterState state) =>
      const MusicPlayerPageRouteData();

  @override
  String get location => GoRouteData.$location('/music');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
