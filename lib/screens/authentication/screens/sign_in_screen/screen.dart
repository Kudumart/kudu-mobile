import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/data/api/model_error.dart';
import 'package:kudu/core/shared_widgets/divider.dart';
import 'package:kudu/core/utils/input_validators.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/providers/auth_viewmodel.dart';
import 'package:kudu/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/screens/authentication/shared_widgets/custom_filled_text_form_field.dart';
import 'package:kudu/screens/authentication/shared_widgets/terms_and_conditions_statement.dart';
import 'package:provider/provider.dart';

import '../../../../data/api/endpoints.dart';
import '../../../../data/storage/shared_preferences.dart';

import '../../../../models/enums_and_extensions.dart';
import '../../../../models/user.dart';
import '../../../../core/constants.dart';
import '../../../../core/images.dart';
import '../../../../core/shared_widgets/back_button.dart';
import '../../../../core/shared_widgets/overlay/overlay.dart';
import '../../../../core/utils/request_operation_wrapper.dart';
import '../../shared_widgets/form_field_title.dart';
import '../../shared_widgets/password_text_form_field.dart';

part 'widgets/sign_in_option_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Map<String, dynamic> _values = {};

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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Login to your Account",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  const Text(
                    "Resume your great shopping experience on Kudu",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 45),

                  // forms
                  const FormFieldTitle("Email"),
                  CustomTextFormField(
                    validator: InputValidator.validateEmail,
                    textEditingController: emailController,
                    hint: "Enter email",
                  ),
                  const SizedBox(height: 23),

                  const FormFieldTitle("Password"),
                  PasswordTextFormField(
                    textEditingController: passwordController,
                  ),
                  const SizedBox(height: 11),

                  // forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () =>
                            const ForgotPasswordScreenRoute().push(context),
                        child: const Text("Forgot your password?",
                            style: TextStyle(
                                color: AppUiColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500))),
                  ),

                  // terms and conditions
                  const SizedBox(height: 33),
                  const TermsAndConditionsStatement(),
                  const SizedBox(height: 24),

                  // login button
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      if (_formKey.currentState!.validate()) {
                        Provider.of<AuthViewmodel>(context, listen: false)
                            .login(
                          context: context,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      }
                    },
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 25),
                  const CustomDivider(withoutMargin: true),
                  const SizedBox(height: 15),
                  _SignInOptionButton(
                      svgAssetIcon: AppUiIcon.facebook,
                      text: "Sign in with Facebook",
                      onPressed: () {}),
                  const SizedBox(height: 11),
                  _SignInOptionButton(
                      svgAssetIcon: AppUiIcon.google,
                      text: "Sign in with Google",
                      onPressed: () {}),
                  const SizedBox(height: 45),

                  // alt auth option
                  const Center(
                      // TODO pass correct value here
                      child: AlternateAuthOption.createAccount(
                          userType: UserType.customer))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//   _submit() {
//     _formKey.currentState!.save();
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     RequestOperationWrapper.executeForegroundRequest(context, request: () {
//       return ApiClient.sendPostRequest(
//         ApiEndpoint.signIn,
//         _values,
//         authenticate: false,
//         readResponseBody: User.fromJson,
//       );
//     }, onError: (apiError) {
//       if (apiError.statusCode == ApiError.unverifiedEmail().statusCode) {
//         AppUiOverlay().showErrorDialog(context, "unverified-email",
//             info: apiError.message,
//             okayButtonText: "Verify Email",
//             onPressedOkayButton: () =>
//                 const ReAskVerificationCodeScreenRoute().push(context),
//             title: apiError.title);
//       } else {
//         AppUiOverlay().showErrorDialog(
//           context,
//           "sign-in",
//           info: apiError.message,
//           title: apiError.title,
//         );
//       }
//     }, onSuccess: (response) {
//       AppStorage.saveUserEmail(_values["email"]);
//       AppStorage.saveAuthenticationToken((response.body as User).token!);
//       AppStorage.saveUserFirstname((response.body as User).firstName);
//       AppUiOverlay()
//           .showSuccessSnackbarMessage(context, message: "Login successful");
//       const HomeScreenRoute().go(context);
//     });
//   }
// }
