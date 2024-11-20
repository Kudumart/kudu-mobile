part of '../screen.dart';

class _ResendPrompt extends StatelessWidget {
  const _ResendPrompt();

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: "Didn't receive the code?  ",
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
            children: [
          TextSpan(
              text: "Resend",
              recognizer: TapGestureRecognizer()
                ..onTap = () => _resendOTP(context),
              style: const TextStyle(
                  fontSize: 14,
                  color: AppUiColor.textBlue,
                  fontWeight: FontWeight.w500))
        ]));
  }

  _resendOTP(BuildContext context) {
    RequestOperationWrapper.executeForegroundRequest(context,
        request: () => ApiClient.sendPostRequest(
            ApiEndpoint.resendVerificationEmail, {"email": AppStorage.userEmail},
            authenticate: false),
        onError: (apiError) => AppUiOverlay().showErrorDialog(
            context, "resend-otp-code",
            info: apiError.message, title: apiError.title),
        onSuccess: (response) {
          AppUiOverlay().showSuccessDialog(
            context,
            "resend-otp-code",
            info: response.message,
          );
        });
  }
}
