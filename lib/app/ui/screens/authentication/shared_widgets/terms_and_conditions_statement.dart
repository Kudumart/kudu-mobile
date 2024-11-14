import 'package:flutter/material.dart';

import '../../../colors.dart';

class TermsAndConditionsStatement extends StatelessWidget {
  const TermsAndConditionsStatement({super.key});

  @override
  Widget build(BuildContext context) {
    const lineHeight = 1.65;
    return RichText(
        text: const TextSpan(
            text: "By proceeding, you agree to the ",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.black,
                height: lineHeight),
            children: [
          TextSpan(
              text: "Terms and Conditions ",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: lineHeight,
                  color: UiColor.textBlue)),
          TextSpan(
              text: "and ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
          TextSpan(
              text: "Privacy Policy",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: lineHeight,
                  color: UiColor.textBlue))
        ]));
  }
}
