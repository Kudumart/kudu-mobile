import 'package:flutter/material.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../constants.dart';
import '../../../../images.dart';

part 'widgets/pin_fields.dart';
part 'widgets/resend_code_prompt.dart';

class ForgotPasswordOTPScreen extends StatelessWidget {
  const ForgotPasswordOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const AppBackButton(),
          centerTitle: true,
          title: Image.asset(UiImage.kuduLogo,
              width: 82, height: 27, fit: BoxFit.cover),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 40, UiConstant.horizontalPadding, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("OTP Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              const Text(
                "Enter the verification code sent to the email provided",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 27),
              const _OTPInput(),
              const SizedBox(height: 30),
              const Center(child: _ResendPrompt()),
              const SizedBox(height: 22),
              ElevatedButton(
                  onPressed: () => const ResetPasswordScreenRoute().go(context),
                  child: const Text("Verify")),
              const SizedBox(height: 30),
              const AlternateAuthOption.loginOnForgotPassword()
            ],
          ),
        ),
      ),
    );
  }
}
