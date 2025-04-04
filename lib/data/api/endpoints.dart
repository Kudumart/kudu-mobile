class ApiEndpoint {
  static const String baseUrl = "https://api.kudumart.com";

  static const String signUpAsCustomer = "/api/auth/register/customer";
  static const String signUpAsVendor = "/api/auth/register/vendor";
  static const String verifyEmail = "/api/auth/verify/email";
  static const String signIn = "/api/auth/login";
  static const String resendVerificationEmail =
      "/api/auth/resend/verification/email";
  static const String forgotPassword = "/api/auth/password/forgot";
  static const String verifyOTP = "/api/auth/password/code/check";
  static const String resetPassword = "/api/auth/password/reset";
  static const String verifyForgotPasswordOTP = "/api/auth/password/code/check";

  static const String userProfile = "/api/user/profile";
  static const String updateProfile = "/api/user/profile/update";
  static const String profilePhoto = "/api/user/profile/photo/update";
  static const String updatePhoneNumber = "/api/user/profile/update/phone";
  static const String updateEmail = "/api/user/profile/update/email";

  static const String verifyUpdatePhoneNumber =
      "/api/user/profile/confirm/phone/number";

  static const String verifyUpdateEmail = "/api/user/profile/confirm/email";

  static const String currency = "/api/vendor/currencies";
  static const String store = "/api/vendor/store";
  static const String product = "/api/vendor/products";
  static const String auctionProduct = "/api/vendor/auction/products";
  static const String fetchVendorProduct = "/api/vendor/vendors/products";

  static const String categories = "/api/vendor/categories";

  static const String subscription = "/api/vendor/subscription/plans";
  static const String makeSubscription = "/api/vendor/subscribe";

  static const String kyc = "/api/vendor/kyc";
  static const String paymentKey = "/api/user/payment/gateway";

  /// expected query parameters conversationId
  static const String chatMessages = "/api/user/messages";
  static const String chatHeaders = "/api/user/conversations";
}
