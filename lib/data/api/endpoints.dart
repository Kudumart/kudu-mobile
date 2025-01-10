class ApiEndpoint {
  static const String baseUrl = "https://kudumarts.victornwadinobi.com";

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
  static const String currency = "/api/vendor/currencies";
  static const String store = "/api//vendor/store";
  static const String kyc = "/api/vendor/kyc";

  /// expected query parameters conversationId
  static const String chatMessages = "/api/user/messages";
  static const String chatHeaders = "/api/user/conversations";
}
