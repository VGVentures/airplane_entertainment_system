import 'package:airplane_entertainment_system/app_router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({
    required GlobalKey<NavigatorState> navigatorKey,
    bool debugLogDiagnostics = false,
  }) {
    _goRouter = _routes(
      navigatorKey,
      debugLogDiagnostics,
    );
  }

  late final GoRouter _goRouter;

  GoRouter get routes => _goRouter;

  GoRouter _routes(
    GlobalKey<NavigatorState> navigatorKey,
    bool debugLogDiagnostics,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: const OverviewPageRouteData().location,
      debugLogDiagnostics: debugLogDiagnostics,
      routes: $appRoutes,
    );
  }
}
