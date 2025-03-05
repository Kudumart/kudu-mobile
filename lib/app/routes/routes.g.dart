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
      $reAskVerificationCodeScreenRoute,
      $verifyOTPScreenRoute,
      $updateOTPScreenRoute,
      $productDetailsScreenRoute,
      $checkoutScreenRoute,
      $productSearchScreenRoute,
      $editProfileScreenRoute,
      $changePasswordScreenRoute,
      $securityAndPrivacyScreenRoute,
      $settingsScreenRoute,
      $auctionLandingScreenRoute,
      $subscriptionScreenRoute,
      $editKYCScreenRoute,
      $doKYCScreenRoute,
      $newPhoneNumberRoute,
      $newEmailScreenRoute,
      $storeProductsScreenRoute,
      $storeDetailsScreenRoute,
      $privacyPolicyScreenRoute,
      $termsAndConditionsScreenRoute,
      $fAQScreenRoute,
      $aboutUsScreenRoute,
      $categoriesScreenRoute,
      $addProductScreenRoute,
      $bookmarkedProductsScreenRoute,
      $chatScreenRoute,
      $notificationsScreenRoute,
      $bidDetailsScreenRoute,
      $auctionSearchScreenRoute,
      $monitorMyBidsScreenRoute,
      $dashboardLayoutShellRouteData,
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
      SignUpOptionsScreenRoute(
        state.extra as UserType,
      );

  String get location => GoRouteData.$location(
        '/sign-up-options',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $signUpScreenRoute => GoRouteData.$route(
      path: '/sign-up',
      factory: $SignUpScreenRouteExtension._fromState,
    );

extension $SignUpScreenRouteExtension on SignUpScreenRoute {
  static SignUpScreenRoute _fromState(GoRouterState state) => SignUpScreenRoute(
        state.extra as UserType,
      );

  String get location => GoRouteData.$location(
        '/sign-up',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
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
      ResetPasswordScreenRoute(
        otp: state.uri.queryParameters['otp']!,
      );

  String get location => GoRouteData.$location(
        '/reset-password',
        queryParams: {
          'otp': otp,
        },
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

RouteBase get $reAskVerificationCodeScreenRoute => GoRouteData.$route(
      path: '/reask-verification',
      factory: $ReAskVerificationCodeScreenRouteExtension._fromState,
    );

extension $ReAskVerificationCodeScreenRouteExtension
    on ReAskVerificationCodeScreenRoute {
  static ReAskVerificationCodeScreenRoute _fromState(GoRouterState state) =>
      const ReAskVerificationCodeScreenRoute();

  String get location => GoRouteData.$location(
        '/reask-verification',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $verifyOTPScreenRoute => GoRouteData.$route(
      path: '/verify-otp',
      factory: $VerifyOTPScreenRouteExtension._fromState,
    );

extension $VerifyOTPScreenRouteExtension on VerifyOTPScreenRoute {
  static VerifyOTPScreenRoute _fromState(GoRouterState state) =>
      VerifyOTPScreenRoute(
        useForgotPasswordFlow: _$convertMapValue('use-forgot-password-flow',
                state.uri.queryParameters, _$boolConverter) ??
            true,
      );

  String get location => GoRouteData.$location(
        '/verify-otp',
        queryParams: {
          if (useForgotPasswordFlow != true)
            'use-forgot-password-flow': useForgotPasswordFlow.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

RouteBase get $updateOTPScreenRoute => GoRouteData.$route(
      path: '/update-otp',
      factory: $UpdateOTPScreenRouteExtension._fromState,
    );

extension $UpdateOTPScreenRouteExtension on UpdateOTPScreenRoute {
  static UpdateOTPScreenRoute _fromState(GoRouterState state) =>
      UpdateOTPScreenRoute(
        isPhoneNumber: _$convertMapValue('is-phone-number',
                state.uri.queryParameters, _$boolConverter) ??
            true,
        data: state.uri.queryParameters['data']!,
      );

  String get location => GoRouteData.$location(
        '/update-otp',
        queryParams: {
          if (isPhoneNumber != true)
            'is-phone-number': isPhoneNumber.toString(),
          'data': data,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $productDetailsScreenRoute => GoRouteData.$route(
      path: '/product-details',
      factory: $ProductDetailsScreenRouteExtension._fromState,
    );

extension $ProductDetailsScreenRouteExtension on ProductDetailsScreenRoute {
  static ProductDetailsScreenRoute _fromState(GoRouterState state) =>
      ProductDetailsScreenRoute(
        state.uri.queryParameters['product-i-d']!,
      );

  String get location => GoRouteData.$location(
        '/product-details',
        queryParams: {
          'product-i-d': productID,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $checkoutScreenRoute => GoRouteData.$route(
      path: '/checkout',
      factory: $CheckoutScreenRouteExtension._fromState,
    );

extension $CheckoutScreenRouteExtension on CheckoutScreenRoute {
  static CheckoutScreenRoute _fromState(GoRouterState state) =>
      const CheckoutScreenRoute();

  String get location => GoRouteData.$location(
        '/checkout',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $productSearchScreenRoute => GoRouteData.$route(
      path: '/search',
      factory: $ProductSearchScreenRouteExtension._fromState,
    );

extension $ProductSearchScreenRouteExtension on ProductSearchScreenRoute {
  static ProductSearchScreenRoute _fromState(GoRouterState state) =>
      ProductSearchScreenRoute(
        state.extra as SearchFilter?,
      );

  String get location => GoRouteData.$location(
        '/search',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $editProfileScreenRoute => GoRouteData.$route(
      path: '/edit-profile',
      factory: $EditProfileScreenRouteExtension._fromState,
    );

extension $EditProfileScreenRouteExtension on EditProfileScreenRoute {
  static EditProfileScreenRoute _fromState(GoRouterState state) =>
      const EditProfileScreenRoute();

  String get location => GoRouteData.$location(
        '/edit-profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $changePasswordScreenRoute => GoRouteData.$route(
      path: '/change-password',
      factory: $ChangePasswordScreenRouteExtension._fromState,
    );

extension $ChangePasswordScreenRouteExtension on ChangePasswordScreenRoute {
  static ChangePasswordScreenRoute _fromState(GoRouterState state) =>
      const ChangePasswordScreenRoute();

  String get location => GoRouteData.$location(
        '/change-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $securityAndPrivacyScreenRoute => GoRouteData.$route(
      path: '/security-privacy',
      factory: $SecurityAndPrivacyScreenRouteExtension._fromState,
    );

extension $SecurityAndPrivacyScreenRouteExtension
    on SecurityAndPrivacyScreenRoute {
  static SecurityAndPrivacyScreenRoute _fromState(GoRouterState state) =>
      const SecurityAndPrivacyScreenRoute();

  String get location => GoRouteData.$location(
        '/security-privacy',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsScreenRoute => GoRouteData.$route(
      path: '/settings',
      factory: $SettingsScreenRouteExtension._fromState,
    );

extension $SettingsScreenRouteExtension on SettingsScreenRoute {
  static SettingsScreenRoute _fromState(GoRouterState state) =>
      const SettingsScreenRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $auctionLandingScreenRoute => GoRouteData.$route(
      path: '/auction-landing',
      factory: $AuctionLandingScreenRouteExtension._fromState,
    );

extension $AuctionLandingScreenRouteExtension on AuctionLandingScreenRoute {
  static AuctionLandingScreenRoute _fromState(GoRouterState state) =>
      const AuctionLandingScreenRoute();

  String get location => GoRouteData.$location(
        '/auction-landing',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $subscriptionScreenRoute => GoRouteData.$route(
      path: '/subscription',
      factory: $SubscriptionScreenRouteExtension._fromState,
    );

extension $SubscriptionScreenRouteExtension on SubscriptionScreenRoute {
  static SubscriptionScreenRoute _fromState(GoRouterState state) =>
      const SubscriptionScreenRoute();

  String get location => GoRouteData.$location(
        '/subscription',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editKYCScreenRoute => GoRouteData.$route(
      path: '/edit-kyc',
      factory: $EditKYCScreenRouteExtension._fromState,
    );

extension $EditKYCScreenRouteExtension on EditKYCScreenRoute {
  static EditKYCScreenRoute _fromState(GoRouterState state) =>
      const EditKYCScreenRoute();

  String get location => GoRouteData.$location(
        '/edit-kyc',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $doKYCScreenRoute => GoRouteData.$route(
      path: '/do-kyc',
      factory: $DoKYCScreenRouteExtension._fromState,
    );

extension $DoKYCScreenRouteExtension on DoKYCScreenRoute {
  static DoKYCScreenRoute _fromState(GoRouterState state) =>
      const DoKYCScreenRoute();

  String get location => GoRouteData.$location(
        '/do-kyc',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $newPhoneNumberRoute => GoRouteData.$route(
      path: '/new-phonenumber',
      factory: $NewPhoneNumberRouteExtension._fromState,
    );

extension $NewPhoneNumberRouteExtension on NewPhoneNumberRoute {
  static NewPhoneNumberRoute _fromState(GoRouterState state) =>
      const NewPhoneNumberRoute();

  String get location => GoRouteData.$location(
        '/new-phonenumber',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $newEmailScreenRoute => GoRouteData.$route(
      path: '/new-email',
      factory: $NewEmailScreenRouteExtension._fromState,
    );

extension $NewEmailScreenRouteExtension on NewEmailScreenRoute {
  static NewEmailScreenRoute _fromState(GoRouterState state) =>
      const NewEmailScreenRoute();

  String get location => GoRouteData.$location(
        '/new-email',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $storeProductsScreenRoute => GoRouteData.$route(
      path: '/store-products',
      factory: $StoreProductsScreenRouteExtension._fromState,
    );

extension $StoreProductsScreenRouteExtension on StoreProductsScreenRoute {
  static StoreProductsScreenRoute _fromState(GoRouterState state) =>
      StoreProductsScreenRoute(
        state.extra as GetStoreModel,
      );

  String get location => GoRouteData.$location(
        '/store-products',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $storeDetailsScreenRoute => GoRouteData.$route(
      path: '/store-details',
      factory: $StoreDetailsScreenRouteExtension._fromState,
    );

extension $StoreDetailsScreenRouteExtension on StoreDetailsScreenRoute {
  static StoreDetailsScreenRoute _fromState(GoRouterState state) =>
      StoreDetailsScreenRoute(
        state.extra as GetStoreModel,
      );

  String get location => GoRouteData.$location(
        '/store-details',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $privacyPolicyScreenRoute => GoRouteData.$route(
      path: '/privacy-policy',
      factory: $PrivacyPolicyScreenRouteExtension._fromState,
    );

extension $PrivacyPolicyScreenRouteExtension on PrivacyPolicyScreenRoute {
  static PrivacyPolicyScreenRoute _fromState(GoRouterState state) =>
      const PrivacyPolicyScreenRoute();

  String get location => GoRouteData.$location(
        '/privacy-policy',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $termsAndConditionsScreenRoute => GoRouteData.$route(
      path: '/terms-and-conditions',
      factory: $TermsAndConditionsScreenRouteExtension._fromState,
    );

extension $TermsAndConditionsScreenRouteExtension
    on TermsAndConditionsScreenRoute {
  static TermsAndConditionsScreenRoute _fromState(GoRouterState state) =>
      const TermsAndConditionsScreenRoute();

  String get location => GoRouteData.$location(
        '/terms-and-conditions',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $fAQScreenRoute => GoRouteData.$route(
      path: '/faq',
      factory: $FAQScreenRouteExtension._fromState,
    );

extension $FAQScreenRouteExtension on FAQScreenRoute {
  static FAQScreenRoute _fromState(GoRouterState state) =>
      const FAQScreenRoute();

  String get location => GoRouteData.$location(
        '/faq',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aboutUsScreenRoute => GoRouteData.$route(
      path: '/about-us',
      factory: $AboutUsScreenRouteExtension._fromState,
    );

extension $AboutUsScreenRouteExtension on AboutUsScreenRoute {
  static AboutUsScreenRoute _fromState(GoRouterState state) =>
      const AboutUsScreenRoute();

  String get location => GoRouteData.$location(
        '/about-us',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $categoriesScreenRoute => GoRouteData.$route(
      path: '/categories',
      factory: $CategoriesScreenRouteExtension._fromState,
    );

extension $CategoriesScreenRouteExtension on CategoriesScreenRoute {
  static CategoriesScreenRoute _fromState(GoRouterState state) =>
      const CategoriesScreenRoute();

  String get location => GoRouteData.$location(
        '/categories',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $addProductScreenRoute => GoRouteData.$route(
      path: '/add-product',
      factory: $AddProductScreenRouteExtension._fromState,
    );

extension $AddProductScreenRouteExtension on AddProductScreenRoute {
  static AddProductScreenRoute _fromState(GoRouterState state) =>
      AddProductScreenRoute(
        storeId: state.uri.queryParameters['store-id'],
        isEditing: _$convertMapValue(
                'is-editing', state.uri.queryParameters, _$boolConverter) ??
            false,
        state.extra as GetProductModel?,
      );

  String get location => GoRouteData.$location(
        '/add-product',
        queryParams: {
          if (storeId != null) 'store-id': storeId,
          if (isEditing != false) 'is-editing': isEditing.toString(),
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $bookmarkedProductsScreenRoute => GoRouteData.$route(
      path: '/bookmarked-products',
      factory: $BookmarkedProductsScreenRouteExtension._fromState,
    );

extension $BookmarkedProductsScreenRouteExtension
    on BookmarkedProductsScreenRoute {
  static BookmarkedProductsScreenRoute _fromState(GoRouterState state) =>
      const BookmarkedProductsScreenRoute();

  String get location => GoRouteData.$location(
        '/bookmarked-products',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatScreenRoute => GoRouteData.$route(
      path: '/chat',
      factory: $ChatScreenRouteExtension._fromState,
    );

extension $ChatScreenRouteExtension on ChatScreenRoute {
  static ChatScreenRoute _fromState(GoRouterState state) => ChatScreenRoute(
        state.extra as ConversationListData,
      );

  String get location => GoRouteData.$location(
        '/chat',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $notificationsScreenRoute => GoRouteData.$route(
      path: '/notifications',
      factory: $NotificationsScreenRouteExtension._fromState,
    );

extension $NotificationsScreenRouteExtension on NotificationsScreenRoute {
  static NotificationsScreenRoute _fromState(GoRouterState state) =>
      const NotificationsScreenRoute();

  String get location => GoRouteData.$location(
        '/notifications',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $bidDetailsScreenRoute => GoRouteData.$route(
      path: '/bid-details',
      factory: $BidDetailsScreenRouteExtension._fromState,
    );

extension $BidDetailsScreenRouteExtension on BidDetailsScreenRoute {
  static BidDetailsScreenRoute _fromState(GoRouterState state) =>
      BidDetailsScreenRoute(
        state.extra as ProductData,
      );

  String get location => GoRouteData.$location(
        '/bid-details',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $auctionSearchScreenRoute => GoRouteData.$route(
      path: '/auction-search',
      factory: $AuctionSearchScreenRouteExtension._fromState,
    );

extension $AuctionSearchScreenRouteExtension on AuctionSearchScreenRoute {
  static AuctionSearchScreenRoute _fromState(GoRouterState state) =>
      const AuctionSearchScreenRoute();

  String get location => GoRouteData.$location(
        '/auction-search',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $monitorMyBidsScreenRoute => GoRouteData.$route(
      path: '/monitor-bids',
      factory: $MonitorMyBidsScreenRouteExtension._fromState,
    );

extension $MonitorMyBidsScreenRouteExtension on MonitorMyBidsScreenRoute {
  static MonitorMyBidsScreenRoute _fromState(GoRouterState state) =>
      const MonitorMyBidsScreenRoute();

  String get location => GoRouteData.$location(
        '/monitor-bids',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $dashboardLayoutShellRouteData => ShellRouteData.$route(
      navigatorKey: DashboardLayoutShellRouteData.$navigatorKey,
      factory: $DashboardLayoutShellRouteDataExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/home',
          factory: $HomeScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/messages',
          factory: $MessagesScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/my-store',
          factory: $MyStoreScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/my-cart',
          factory: $MyCartScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/profile',
          factory: $ProfileScreenRouteExtension._fromState,
        ),
      ],
    );

extension $DashboardLayoutShellRouteDataExtension
    on DashboardLayoutShellRouteData {
  static DashboardLayoutShellRouteData _fromState(GoRouterState state) =>
      const DashboardLayoutShellRouteData();
}

extension $HomeScreenRouteExtension on HomeScreenRoute {
  static HomeScreenRoute _fromState(GoRouterState state) =>
      const HomeScreenRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MessagesScreenRouteExtension on MessagesScreenRoute {
  static MessagesScreenRoute _fromState(GoRouterState state) =>
      const MessagesScreenRoute();

  String get location => GoRouteData.$location(
        '/messages',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MyStoreScreenRouteExtension on MyStoreScreenRoute {
  static MyStoreScreenRoute _fromState(GoRouterState state) =>
      const MyStoreScreenRoute();

  String get location => GoRouteData.$location(
        '/my-store',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MyCartScreenRouteExtension on MyCartScreenRoute {
  static MyCartScreenRoute _fromState(GoRouterState state) =>
      const MyCartScreenRoute();

  String get location => GoRouteData.$location(
        '/my-cart',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileScreenRouteExtension on ProfileScreenRoute {
  static ProfileScreenRoute _fromState(GoRouterState state) =>
      const ProfileScreenRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
