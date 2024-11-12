// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $welcomeScreenRoute,
      $welcomeScreen2Route,
      $onboardingScreenRoute,
      $signUpOptionsScreenRoute,
      $signUpScreenRoute,
      $signInScreenRoute,
      $resetPasswordScreenRoute,
      $forgotPasswordScreenRoute,
      $forgotPasswordOTPScreenRoute,
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

RouteBase get $signUpOptionsScreenRoute => GoRouteData.$route(
      path: '/sign-up-options',
      factory: $SignUpOptionsScreenRouteExtension._fromState,
    );

extension $SignUpOptionsScreenRouteExtension on SignUpOptionsScreenRoute {
  static SignUpOptionsScreenRoute _fromState(GoRouterState state) =>
      const SignUpOptionsScreenRoute();

  String get location => GoRouteData.$location(
        '/sign-up-options',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signUpScreenRoute => GoRouteData.$route(
      path: '/sign-up',
      factory: $SignUpScreenRouteExtension._fromState,
    );

extension $SignUpScreenRouteExtension on SignUpScreenRoute {
  static SignUpScreenRoute _fromState(GoRouterState state) =>
      const SignUpScreenRoute();

  String get location => GoRouteData.$location(
        '/sign-up',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInScreenRoute => GoRouteData.$route(
      path: '/sign-in',
      factory: $SignInScreenRouteExtension._fromState,
    );

extension $SignInScreenRouteExtension on SignInScreenRoute {
  static SignInScreenRoute _fromState(GoRouterState state) =>
      const SignInScreenRoute();

  String get location => GoRouteData.$location(
        '/sign-in',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $resetPasswordScreenRoute => GoRouteData.$route(
      path: '/reset-password',
      factory: $ResetPasswordScreenRouteExtension._fromState,
    );

extension $ResetPasswordScreenRouteExtension on ResetPasswordScreenRoute {
  static ResetPasswordScreenRoute _fromState(GoRouterState state) =>
      const ResetPasswordScreenRoute();

  String get location => GoRouteData.$location(
        '/reset-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgotPasswordScreenRoute => GoRouteData.$route(
      path: '/forgot-password',
      factory: $ForgotPasswordScreenRouteExtension._fromState,
    );

extension $ForgotPasswordScreenRouteExtension on ForgotPasswordScreenRoute {
  static ForgotPasswordScreenRoute _fromState(GoRouterState state) =>
      const ForgotPasswordScreenRoute();

  String get location => GoRouteData.$location(
        '/forgot-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgotPasswordOTPScreenRoute => GoRouteData.$route(
      path: '/forgot-password-otp',
      factory: $ForgotPasswordOTPScreenRouteExtension._fromState,
    );

extension $ForgotPasswordOTPScreenRouteExtension
    on ForgotPasswordOTPScreenRoute {
  static ForgotPasswordOTPScreenRoute _fromState(GoRouterState state) =>
      const ForgotPasswordOTPScreenRoute();

  String get location => GoRouteData.$location(
        '/forgot-password-otp',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
