part of '../screen.dart';

class _ResendPrompt extends StatelessWidget {
  const _ResendPrompt();

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: const TextSpan(
            text: "Didn't receive the code?  ",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
            children: [
          TextSpan(
              text: "Resend",
              style: TextStyle(
                  fontSize: 14,
                  color: UiColor.textBlue,
                  fontWeight: FontWeight.w500))
        ]));
  }
}
