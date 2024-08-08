// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeScreenRouteData,
    ];

RouteBase get $homeScreenRouteData => StatefulShellRouteData.$route(
      navigatorContainerBuilder: HomeScreenRouteData.$navigatorContainerBuilder,
      factory: $HomeScreenRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/overview',
              name: 'overview',
              factory: $OverviewPageRouteDataExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/music',
              name: 'music',
              factory: $MusicPlayerPageRouteDataExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $HomeScreenRouteDataExtension on HomeScreenRouteData {
  static HomeScreenRouteData _fromState(GoRouterState state) =>
      const HomeScreenRouteData();
}

extension $OverviewPageRouteDataExtension on OverviewPageRouteData {
  static OverviewPageRouteData _fromState(GoRouterState state) =>
      const OverviewPageRouteData();

  String get location => GoRouteData.$location(
        '/overview',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MusicPlayerPageRouteDataExtension on MusicPlayerPageRouteData {
  static MusicPlayerPageRouteData _fromState(GoRouterState state) =>
      const MusicPlayerPageRouteData();

  String get location => GoRouteData.$location(
        '/music',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
