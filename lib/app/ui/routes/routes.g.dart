// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $welcomeScreenRoute,
      $welcomeScreen2Route,
      $onboardingScreenRoute,
    ];

RouteBase get $welcomeScreenRoute => GoRouteData.$route(
      path: '/welcome',
      factory: $WelcomeScreenRouteExtension._fromState,
    );

extension $WelcomeScreenRouteExtension on WelcomeScreenRoute {
  static WelcomeScreenRoute _fromState(GoRouterState state) =>
      const WelcomeScreenRoute();

  String get location => GoRouteData.$location(
        '/welcome',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $welcomeScreen2Route => GoRouteData.$route(
      path: '/welcome-2',
      factory: $WelcomeScreen2RouteExtension._fromState,
    );

extension $WelcomeScreen2RouteExtension on WelcomeScreen2Route {
  static WelcomeScreen2Route _fromState(GoRouterState state) =>
      const WelcomeScreen2Route();

  String get location => GoRouteData.$location(
        '/welcome-2',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingScreenRoute => GoRouteData.$route(
      path: '/onboarding',
      factory: $OnboardingScreenRouteExtension._fromState,
    );

extension $OnboardingScreenRouteExtension on OnboardingScreenRoute {
  static OnboardingScreenRoute _fromState(GoRouterState state) =>
      const OnboardingScreenRoute();

  String get location => GoRouteData.$location(
        '/onboarding',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
