import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/ui/screens/welcome/screen.dart';

import '../screens/authentication/screens/forgot_password/screen.dart';
import '../screens/authentication/screens/otp_screen/screen.dart';
import '../screens/authentication/screens/reset_password_screen/screen.dart';
import '../screens/authentication/screens/sign_in_screen/screen.dart';
import '../screens/authentication/screens/sign_up_options_screen/screen.dart';
import '../screens/authentication/screens/sign_up_screen/screen.dart';
import '../screens/dashboard_layout/dashboard_layout.dart';
import '../screens/dashboard_layout/screens/account/screen.dart';
import '../screens/dashboard_layout/screens/cart/screen.dart';
import '../screens/dashboard_layout/screens/categories/screen.dart';
import '../screens/dashboard_layout/screens/messages/screen.dart';
import '../screens/dashboard_layout/screens/home/screen.dart';
import '../screens/onboarding/screen.dart';

part 'dashboard_layout_routes.dart';
part "routes.g.dart";

/*
 After adding or removing any screen route, 
 run `dart run build_runner build` to rebuild routes.g.dart

 For more info, see https://pub.dev/go_router_builder
*/

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "root");
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "shell");

final routerConfig = GoRouter(
  routes: $appRoutes,
  initialLocation: "/welcome",
  navigatorKey: _rootNavigatorKey
);

const _leftToRightSlideTransitionBeginOffset = Offset(-1.0, 0.0);
const _rightToLeftSlideTransitionBeginOffset = Offset(1.0, 0.0);
const _topToBottomSlideTransitionBeginOffset = Offset(0.0, -1.0);
const _bottomToTopSlideTransitionBeginOffset = Offset(0.0, 1.0);

const _allSlideTransitionEndOffset = Offset.zero;

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
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<SignUpOptionsScreenRoute>(path: '/sign-up-options')
class SignUpOptionsScreenRoute extends GoRouteData {
  const SignUpOptionsScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SignUpOptionsScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<SignUpScreenRoute>(path: '/sign-up')
class SignUpScreenRoute extends GoRouteData {
  const SignUpScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SignUpScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<SignInScreenRoute>(path: '/sign-in')
class SignInScreenRoute extends GoRouteData {
  const SignInScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SignInScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<ResetPasswordScreenRoute>(path: '/reset-password')
class ResetPasswordScreenRoute extends GoRouteData {
  const ResetPasswordScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ResetPasswordScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<ForgotPasswordScreenRoute>(path: '/forgot-password')
class ForgotPasswordScreenRoute extends GoRouteData {
  const ForgotPasswordScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<ForgotPasswordOTPScreenRoute>(path: '/forgot-password-otp')
class ForgotPasswordOTPScreenRoute extends GoRouteData {
  const ForgotPasswordOTPScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ForgotPasswordOTPScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

