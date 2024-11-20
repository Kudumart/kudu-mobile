import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kudu/app/data/storage/shared_preferences.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../data/api/client.dart';
import '../../../../../data/api/endpoints.dart';
import '../../../../constants.dart';
import '../../../../images.dart';
import '../../../../shared_widgets/overlay/overlay.dart';
import '../../../../utils/request_operation_wrapper.dart';

part 'widgets/pin_fields.dart';
part 'widgets/resend_code_prompt.dart';

class VerifyOTPScreen extends StatefulWidget {
  final bool useForgotPasswordFlow;
  const VerifyOTPScreen({this.useForgotPasswordFlow = true, super.key});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  String? _code;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const AppBackButton(),
          centerTitle: true,
          title: Image.asset(AppUiImage.kuduLogo,
              width: 82, height: 27, fit: BoxFit.cover),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 40,
              UiConstant.horizontalPadding, 20),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("OTP Verification",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the verification code sent to the email provided",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 27),
              Form(
                  key: _formKey,
                  child: _OTPInput(
                    onSaved: (input) => _code = input,
                    onCompleted: (input) {
                      _code = input;
                      _submit();
                    },
                  )),
              const SizedBox(height: 30),
              const _ResendPrompt(),
              const SizedBox(height: 22),
              ElevatedButton(onPressed: _submit, child: const Text("Verify")),
              const SizedBox(height: 30),
              const AlternateAuthOption.loginOnForgotPassword()
            ],
          ),
        ),
      ),
    );
  }

  _submit() {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    RequestOperationWrapper.executeForegroundRequest(context,
        request: () => ApiClient.sendPostRequest(
            widget.useForgotPasswordFlow
                ? ApiEndpoint.verifyForgotPasswordOTP
                : ApiEndpoint.verifyEmail,
            {"email": AppStorage.userEmail, "otpCode": _code},
            authenticate: false),
        onError: (apiError) => AppUiOverlay().showErrorDialog(
            context, "otp-verification",
            info: apiError.message, title: apiError.title),
        onSuccess: (response) {
          AppUiOverlay().showSuccessDialog(context, "otp-verification",
              info: response.message,
              okayButtonText: widget.useForgotPasswordFlow
                  ? "Reset your password"
                  : "Proceed to Login",
              onPressedOkayButton: () => widget.useForgotPasswordFlow
                  ? ResetPasswordScreenRoute(otp: _code!).go(context)
                  : const SignInScreenRoute().go(context));
        });
  }
}
