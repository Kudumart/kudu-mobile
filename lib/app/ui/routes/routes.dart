import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/ui/screens/edit_profile/screen.dart';
import 'package:kudu/app/ui/screens/security_and_privacy/screen.dart';
import 'package:kudu/app/ui/screens/settings/screen.dart';
import 'package:kudu/app/ui/screens/welcome/screen.dart';

import '../../data/storage/shared_preferences.dart';
import '../screens/authentication/screens/forgot_password/screen.dart';
import '../screens/authentication/screens/otp_screen/screen.dart';
import '../screens/authentication/screens/reask_verification_code/screen.dart';
import '../screens/authentication/screens/reset_password_screen/screen.dart';
import '../screens/authentication/screens/sign_in_screen/screen.dart';
import '../screens/authentication/screens/sign_up_options_screen/screen.dart';
import '../screens/authentication/screens/sign_up_screen/screen.dart';
import '../screens/change_password/screen.dart';
import '../screens/checkout/screen.dart';
import '../screens/dashboard_layout/dashboard_layout.dart';
import '../screens/dashboard_layout/screens/cart/screen.dart';
import '../screens/dashboard_layout/screens/messages/screen.dart';
import '../screens/dashboard_layout/screens/home/screen.dart';
import '../screens/dashboard_layout/screens/profile/screen.dart';
import '../screens/onboarding/screen.dart';
import '../screens/product_details/screen.dart';
import '../screens/search/screen.dart';

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
    initialLocation: _determineInitialLocation(),
    navigatorKey: _rootNavigatorKey);

_determineInitialLocation() {
  final token = AppStorage.authenticationToken;
  if (token == null || token.isEmpty) {
    return "/welcome";
  }
  return "/home";
}

const _leftToRightSlideTransitionBeginOffset = Offset(-1.0, 0.0);
const _rightToLeftSlideTransitionBeginOffset = Offset(1.0, 0.0);
const _topToBottomSlideTransitionBeginOffset = Offset(0.0, -1.0);
// const _bottomToTopSlideTransitionBeginOffset = Offset(0.0, 1.0);

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
  /// [otp] entered on the verify otp screen
  final String otp;
  const ResetPasswordScreenRoute({required this.otp});

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: ResetPasswordScreen(otp: otp),
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

@TypedGoRoute<ReAskVerificationCodeScreenRoute>(path: '/reask-verification')
class ReAskVerificationCodeScreenRoute extends GoRouteData {
  const ReAskVerificationCodeScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ReAskVerificationCodeScreen(),
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

@TypedGoRoute<VerifyOTPScreenRoute>(path: '/verify-otp')
class VerifyOTPScreenRoute extends GoRouteData {
  final bool useForgotPasswordFlow;
  const VerifyOTPScreenRoute({this.useForgotPasswordFlow = true});

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: VerifyOTPScreen(useForgotPasswordFlow: useForgotPasswordFlow),
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

@TypedGoRoute<ProductDetailsScreenRoute>(path: '/product-details')
class ProductDetailsScreenRoute extends GoRouteData {
  const ProductDetailsScreenRoute(this.productID);

  final String productID;

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: ProductDetailsScreen(productID: productID),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _leftToRightSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<CheckoutScreenRoute>(path: '/checkout')
class CheckoutScreenRoute extends GoRouteData {
  const CheckoutScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const CheckoutScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _leftToRightSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<SearchScreenRoute>(path: '/search')
class SearchScreenRoute extends GoRouteData {
  const SearchScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SearchScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _leftToRightSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<EditProfileScreenRoute>(path: '/edit-profile')
class EditProfileScreenRoute extends GoRouteData {
  const EditProfileScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const EditProfileScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _leftToRightSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<ChangePasswordScreenRoute>(path: '/change-password')
class ChangePasswordScreenRoute extends GoRouteData {
  const ChangePasswordScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ChangePasswordScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _leftToRightSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<SecurityAndPrivacyScreenRoute>(path: '/security-privacy')
class SecurityAndPrivacyScreenRoute extends GoRouteData {
  const SecurityAndPrivacyScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SecurityAndPrivacyScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _leftToRightSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

@TypedGoRoute<SettingsScreenRoute>(path: '/settings')
class SettingsScreenRoute extends GoRouteData {
  const SettingsScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _leftToRightSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}