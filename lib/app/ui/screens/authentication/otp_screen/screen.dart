import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../images.dart';

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
          backgroundColor: Colors.white,
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(18, 25, 0, 0),
            child: GestureDetector(
              onTap: context.pop,
              child: const Text("Back",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          centerTitle: true,
          title: Image.asset(AppImage.kuduLogo,
              width: 82, height: 27, fit: BoxFit.cover),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(18, 40, 18, 20),
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
              ElevatedButton(onPressed: () => const ResetPasswordScreenRoute().go(context), child: const Text("Verify")),
              const SizedBox(height: 30),
              const AlternateAuthOption.loginOnForgotPassword()
            ],
          ),
        ),
      ),
    );
  }
}