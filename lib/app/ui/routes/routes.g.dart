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
      $productDetailsScreenRoute,
      $checkoutScreenRoute,
      $searchScreenRoute,
      $editProfileScreenRoute,
      $changePasswordScreenRoute,
      $securityAndPrivacyScreenRoute,
      $settingsScreenRoute,
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

RouteBase get $searchScreenRoute => GoRouteData.$route(
      path: '/search',
      factory: $SearchScreenRouteExtension._fromState,
    );

extension $SearchScreenRouteExtension on SearchScreenRoute {
  static SearchScreenRoute _fromState(GoRouterState state) =>
      const SearchScreenRoute();

  String get location => GoRouteData.$location(
        '/search',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
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
          path: '/cart',
          factory: $CartScreenRouteExtension._fromState,
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

extension $CartScreenRouteExtension on CartScreenRoute {
  static CartScreenRoute _fromState(GoRouterState state) =>
      const CartScreenRoute();

  String get location => GoRouteData.$location(
        '/cart',
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
