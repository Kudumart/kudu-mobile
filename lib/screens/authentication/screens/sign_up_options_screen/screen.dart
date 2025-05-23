import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:provider/provider.dart';

import '../../../../models/enums_and_extensions.dart';
import '../../../../core/images.dart';
import '../../../../providers/auth_viewmodel.dart';
import '../../shared_widgets/terms_and_conditions_statement.dart';

part 'widgets/sign_up_option_button.dart';
part 'widgets/divider.dart';

class SignUpOptionsScreen extends StatelessWidget {
  final UserType userType;
  const SignUpOptionsScreen(this.userType, {super.key});

  @override
  Widget build(BuildContext context) {
    final String accountType = userType == UserType.vendor ? "Vendor" : "Kudu";

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(AppUiImage.kuduLogo,
            width: 82, height: 27, fit: BoxFit.cover),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
            UiConstant.horizontalPadding, 40, UiConstant.horizontalPadding, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    text: "Create a ",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    children: [
                  TextSpan(
                    text: accountType,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppUiColor.primary),
                  ),
                  const TextSpan(
                      text: " Account",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ))
                ])),
            const SizedBox(height: 10),
            const Text(
              "One last step before continuing to app",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),

            // options
            const SizedBox(height: 26),
            _SignUpOptionButton(
                svgAssetIcon: AppUiIcon.email,
                text: "Sign up with email",
                onPressed: () => SignUpScreenRoute(userType).push(context)),
            // const SizedBox(height: 11),
            // _SignUpOptionButton(
            //     svgAssetIcon: AppUiIcon.facebook,
            //     text: "Sign up with Facebook",
            //     onPressed: () {}),
            const SizedBox(height: 11),
            _SignUpOptionButton(
                svgAssetIcon: AppUiIcon.google,
                text: "Sign up with Google",
                onPressed: () {
                  Provider.of<AuthViewmodel>(context, listen: false).signInWithGoogle(
                    context,
                  );
                }),

            // divider
            const SizedBox(height: 12),
            const Center(child: _OrDivider()),

            // terms and conditions
            const SizedBox(height: 19),
            const TermsAndConditionsStatement(),
            const Expanded(child: SizedBox()),

            // login
            const Center(child: AlternateAuthOption.login()),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                  onTap: () =>
                      const ReAskVerificationCodeScreenRoute().push(context),
                  child: const Text(
                    "Or Verify your Email",
                    style: TextStyle(
                        color: AppUiColor.iconBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decorationColor: Colors.grey,
                        decoration: TextDecoration.underline),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
