import 'package:flutter/material.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/routes/routes.dart';

class AlternateAuthOption extends StatelessWidget {
  final String _actionButtonText;
  final String _introText;
  final bool _signInOnPressedActionButton;
  const AlternateAuthOption.login({super.key})
      : _actionButtonText = "Log in",
        _introText = "Already have a Kudu account?",
        _signInOnPressedActionButton = true;
  const AlternateAuthOption.createAccount({super.key})
      : _actionButtonText = "Create one",
        _signInOnPressedActionButton = false,
        _introText = "Don't have an account?";
  const AlternateAuthOption.loginOnForgotPassword({super.key})
      : _actionButtonText = "Log in",
        _signInOnPressedActionButton = true,
        _introText = "Remember password?";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_introText,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _onPressedActionButton(context),
          child: Text(_actionButtonText,
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.textBlue,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 3),
        GestureDetector(
          onTap: () => _onPressedActionButton(context),
          child: const Icon(
            Icons.arrow_forward,
            size: 16,
            color: AppColor.textBlue,
          ),
        )
      ],
    );
  }

  _onPressedActionButton(BuildContext context) {
    if (_signInOnPressedActionButton) {
      const SignInScreenRoute().push(context);
      return;
    }
    const SignUpOptionsScreenRoute().push(context);
  }
}
