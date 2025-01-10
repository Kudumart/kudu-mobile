import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/data/storage/shared_preferences.dart';
import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/screens/about_us/screen.dart';
import 'package:kudu/screens/edit_profile/screen.dart';
import 'package:kudu/screens/security_and_privacy/screen.dart';
import 'package:kudu/screens/settings/screen.dart';
import 'package:kudu/screens/welcome/screen.dart';

import '../../models/auction.dart';
import '../../models/chat_header.dart';
import '../../models/enums_and_extensions.dart';
import '../../models/search_filter.dart';
import '../../models/store.dart';
import '../../screens/add_product/screen.dart';
import '../../screens/bid_details/screen.dart';
import '../../screens/auction_landing/screen.dart';
import '../../screens/auction_search.dart/screen.dart';
import '../../screens/authentication/screens/forgot_password/screen.dart';
import '../../screens/authentication/screens/otp_screen/screen.dart';
import '../../screens/authentication/screens/reask_verification_code/screen.dart';
import '../../screens/authentication/screens/reset_password_screen/screen.dart';
import '../../screens/authentication/screens/sign_in_screen/screen.dart';
import '../../screens/authentication/screens/sign_up_options_screen/screen.dart';
import '../../screens/authentication/screens/sign_up_screen/screen.dart';
import '../../screens/bookmarked_products/screen.dart';
import '../../screens/categories/screen.dart';
import '../../screens/change_password/screen.dart';
import '../../screens/chat/screen.dart';
import '../../screens/checkout/screen.dart';
import '../../screens/dashboard_layout/dashboard_layout.dart';
import '../../screens/do_kyc/screen.dart';
import '../../screens/faq/screen.dart';
import '../../screens/manage_store_products/screen.dart';
import '../../screens/dashboard_layout/screens/messages/screen.dart';
import '../../screens/dashboard_layout/screens/home/screen.dart';
import '../../screens/dashboard_layout/screens/profile/screen.dart';
import '../../screens/monitor_bids/screen.dart';
import '../../screens/store_details/screen.dart';
import '../../screens/edit_kyc/screen.dart';
import '../../screens/dashboard_layout/screens/my_store/screen.dart';
import '../../screens/notifications/screen.dart';
import '../../screens/onboarding/screen.dart';
import '../../screens/privacy_policy/screen.dart';
import '../../screens/product_details/screen.dart';
import '../../screens/product_search/screen.dart';
import '../../screens/subscription/screen.dart';
import '../../screens/terms_and_conditions/screen.dart';

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
    initialLocation: _determineInitialRoute(),
    navigatorKey: _rootNavigatorKey);

_determineInitialRoute() {
  // if (isLoggedIn) {
  //   return "/home";
  // }
  return "/welcome";
}

const _leftToRightSlideTransitionBeginOffset = Offset(-1.0, 0.0);
const _rightToLeftSlideTransitionBeginOffset = Offset(1.0, 0.0);
//const _topToBottomSlideTransitionBeginOffset = Offset(0.0, -1.0);
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
  const SignUpOptionsScreenRoute(this.$extra);

  final UserType $extra;

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: SignUpOptionsScreen($extra),
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
  const SignUpScreenRoute(this.$extra);

  final UserType $extra;

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: SignUpScreen($extra),
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

@TypedGoRoute<ProductSearchScreenRoute>(path: '/search')
class ProductSearchScreenRoute extends GoRouteData {
  final SearchFilter? $extra;
  const ProductSearchScreenRoute([this.$extra]);

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: ProductSearchScreen(searchFilter: $extra),
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

@TypedGoRoute<AuctionLandingScreenRoute>(path: '/auction-landing')
class AuctionLandingScreenRoute extends GoRouteData {
  const AuctionLandingScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AuctionLandingScreen(),
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

@TypedGoRoute<SubscriptionScreenRoute>(path: '/subscription')
class SubscriptionScreenRoute extends GoRouteData {
  const SubscriptionScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SubscriptionScreen(),
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

@TypedGoRoute<EditKYCScreenRoute>(path: '/edit-kyc')
class EditKYCScreenRoute extends GoRouteData {
  const EditKYCScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const EditKYCScreen(),
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

@TypedGoRoute<DoKYCScreenRoute>(path: '/do-kyc')
class DoKYCScreenRoute extends GoRouteData {
  const DoKYCScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const DoKYCScreen(),
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

@TypedGoRoute<StoreProductsScreenRoute>(path: '/store-products')
class StoreProductsScreenRoute extends GoRouteData {
  const StoreProductsScreenRoute(this.$extra);

  final GetStoreModel $extra;

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: StoreProductsScreen($extra),
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

@TypedGoRoute<StoreDetailsScreenRoute>(path: '/store-details')
class StoreDetailsScreenRoute extends GoRouteData {
  final GetStoreModel $extra;
  const StoreDetailsScreenRoute(this.$extra);

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: StoreDetailsScreen($extra),
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

@TypedGoRoute<PrivacyPolicyScreenRoute>(path: '/privacy-policy')
class PrivacyPolicyScreenRoute extends GoRouteData {
  const PrivacyPolicyScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const PrivacyPolicyScreen(),
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

@TypedGoRoute<TermsAndConditionsScreenRoute>(path: '/terms-and-conditions')
class TermsAndConditionsScreenRoute extends GoRouteData {
  const TermsAndConditionsScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const TermsAndConditionsScreen(),
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

@TypedGoRoute<FAQScreenRoute>(path: '/faq')
class FAQScreenRoute extends GoRouteData {
  const FAQScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const FAQScreen(),
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

@TypedGoRoute<AboutUsScreenRoute>(path: '/about-us')
class AboutUsScreenRoute extends GoRouteData {
  const AboutUsScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AboutUsScreen(),
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

@TypedGoRoute<CategoriesScreenRoute>(path: '/categories')
class CategoriesScreenRoute extends GoRouteData {
  const CategoriesScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const CategoriesScreen(),
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

@TypedGoRoute<AddProductScreenRoute>(path: '/add-product')
class AddProductScreenRoute extends GoRouteData {
  const AddProductScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AddProductScreen(),
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

@TypedGoRoute<BookmarkedProductsScreenRoute>(path: '/bookmarked-products')
class BookmarkedProductsScreenRoute extends GoRouteData {
  const BookmarkedProductsScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const BookmarkedProductsScreen(),
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

@TypedGoRoute<ChatScreenRoute>(path: '/chat')
class ChatScreenRoute extends GoRouteData {
  ChatScreenRoute(this.$extra);

  final ChatHeader $extra;

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: ChatScreen($extra),
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

@TypedGoRoute<NotificationsScreenRoute>(path: '/notifications')
class NotificationsScreenRoute extends GoRouteData {
  const NotificationsScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const NotificationsScreen(),
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

@TypedGoRoute<BidDetailsScreenRoute>(path: '/bid-details')
class BidDetailsScreenRoute extends GoRouteData {
  const BidDetailsScreenRoute(this.$extra);

  final Auction $extra;

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: BidDetailsScreen($extra),
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

@TypedGoRoute<AuctionSearchScreenRoute>(path: '/auction-search')
class AuctionSearchScreenRoute extends GoRouteData {
  const AuctionSearchScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AuctionSearchScreen(),
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

@TypedGoRoute<MonitorMyBidsScreenRoute>(path: '/monitor-bids')
class MonitorMyBidsScreenRoute extends GoRouteData {
  const MonitorMyBidsScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MonitorMyBidsScreen(),
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
