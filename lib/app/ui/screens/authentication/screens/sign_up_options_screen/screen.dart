import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/alternate_auth_option.dart';

import '../../../../images.dart';
import '../../shared_widgets/terms_and_conditions_statement.dart';

part 'widgets/sign_up_option_button.dart';
part 'widgets/divider.dart';

class SignUpOptionsScreen extends StatelessWidget {
  const SignUpOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.fromLTRB(18, 25, 0, 0),
          child: Text("Cancel",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        centerTitle: true,
        title: Image.asset(UiImage.kuduLogo,
            width: 82, height: 27, fit: BoxFit.cover),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 40, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create a Kudu Account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            const Text(
              "One last step before continuing to app",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),

            // options
            const SizedBox(height: 26),
            _SignUpOptionButton(
                svgAssetIcon: UiIcon.email,
                text: "Sign up with email",
                onPressed: () => const SignUpScreenRoute().push(context)),
            const SizedBox(height: 11),
            _SignUpOptionButton(
                svgAssetIcon: UiIcon.facebook,
                text: "Sign up with Facebook",
                onPressed: () {}),
            const SizedBox(height: 11),
            _SignUpOptionButton(
                svgAssetIcon: UiIcon.google,
                text: "Sign up with Google",
                onPressed: () {}),

            // divider
            const SizedBox(height: 12),
            const Center(child: _OrDivider()),

            // terms and conditions
            const SizedBox(height: 19),
            const TermsAndConditionsStatement(),
            const Expanded(child: SizedBox()),

            // login
            const Center(child: AlternateAuthOption.login())
          ],
        ),
      ),
    );
  }
}
