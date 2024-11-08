import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/ui/screens/welcome/screen.dart';

import '../screens/onboarding/screen.dart';

part "routes.g.dart";

/*
 On add any new screen or deleting an existing screen, 
 run `dart run build_runner build` to rebuild routes.g.dart

 For more info, see https://pub.dev/go_router_builder
*/

final routerConfig = GoRouter(
  routes: $appRoutes,
  initialLocation: "/welcome",
);

@TypedGoRoute<WelcomeScreenRoute>(path: '/welcome')
class WelcomeScreenRoute extends GoRouteData {
  const WelcomeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WelcomeScreen();
}

@TypedGoRoute<WelcomeScreen2Route>(path: '/welcome-2')
class WelcomeScreen2Route extends GoRouteData {
  const WelcomeScreen2Route();

  @override
  CustomTransitionPage<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) {
    return CustomTransitionPage<void>(
        key: state.pageKey,
        child: const WelcomeScreen2(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        });
  }
}

@TypedGoRoute<OnboardingScreenRoute>(path: '/onboarding')
class OnboardingScreenRoute extends GoRouteData {
  const OnboardingScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingScreen();
}
