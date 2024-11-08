import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/ui/screens/welcome/screen.dart';

part "routes.g.dart";

final routerConfig = GoRouter(
  routes: $appRoutes,
  initialLocation: "/",
);

@TypedGoRoute<WelcomeScreenRoute>(path: '/')
class WelcomeScreenRoute extends GoRouteData {
  const WelcomeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WelcomeScreen();
}