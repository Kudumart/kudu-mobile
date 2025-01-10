import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kudu/app/routes/routes.dart';

import '../../../core/colors.dart';

class TermsAndConditionsStatement extends StatelessWidget {
  const TermsAndConditionsStatement({super.key});

  @override
  Widget build(BuildContext context) {
    const lineHeight = 1.65;
    return RichText(
        text: TextSpan(
            text: "By proceeding, you agree to the ",
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.black,
                height: lineHeight),
            children: [
          TextSpan(
              text: "Terms and Conditions ",
              recognizer: TapGestureRecognizer()
                ..onTap = () => const TermsAndConditionsScreenRoute().push(context),
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: lineHeight,
                  color: AppUiColor.textBlue)),
          const TextSpan(
              text: "and ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
          TextSpan(
              text: "Privacy Policy",
              recognizer: TapGestureRecognizer()
                ..onTap = () => const PrivacyPolicyScreenRoute().push(context),
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: lineHeight,
                  color: AppUiColor.textBlue))
        ]));
  }
}
