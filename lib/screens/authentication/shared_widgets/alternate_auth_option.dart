import 'package:flutter/material.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/app/routes/routes.dart';

import '../../../models/enums_and_extensions.dart';

class AlternateAuthOption extends StatelessWidget {
  final UserType userType;
  final String _actionButtonText;
  final String _introText;
  final bool _signInOnPressedActionButton;
  const AlternateAuthOption.login({super.key})
      : _actionButtonText = "Log in",
        userType = UserType.unknown,
        _introText = "Already have a Kudu account?",
        _signInOnPressedActionButton = true;
  const AlternateAuthOption.createAccount({required this.userType, super.key})
      : _actionButtonText = "Create one",
        _signInOnPressedActionButton = false,
        _introText = "Don't have an account?";
  const AlternateAuthOption.loginOnForgotPassword({super.key})
      : _actionButtonText = "Log in",
        userType = UserType.unknown,
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
                  fontSize: 15,
                  color: AppUiColor.textBlue,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 3),
        GestureDetector(
          onTap: () => _onPressedActionButton(context),
          child: const Icon(
            Icons.arrow_forward,
            size: 16,
            color: AppUiColor.textBlue,
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
    SignUpOptionsScreenRoute(userType).push(context);
  }
}
