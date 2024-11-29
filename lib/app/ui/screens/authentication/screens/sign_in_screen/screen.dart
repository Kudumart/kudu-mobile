import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/ui/shared_widgets/divider.dart';
import 'package:kudu/app/ui/utils/input_validators.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/custom_text_form_field.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/terms_and_conditions_statement.dart';

import '../../../../../data/api/client.dart';
import '../../../../../data/api/endpoints.dart';
import '../../../../../data/storage/shared_preferences.dart';

import '../../../../../models/user.dart';
import '../../../../constants.dart';
import '../../../../images.dart';
import '../../../../shared_widgets/back_button.dart';
import '../../../../shared_widgets/overlay/overlay.dart';
import '../../../../utils/request_operation_wrapper.dart';
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
                  onSaved: (value) => _values["email"] = value,
                  hint: "Enter email",
                ),
                const SizedBox(height: 23),

                const FormFieldTitle("Password"),
                PasswordTextFormField(
                  onSaved: (value) => _values["password"] = value,
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
                ElevatedButton(onPressed: _submit, child: const Text("Login")),
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
                const Expanded(child: SizedBox()),

                // alt auth option
                const Center(child: AlternateAuthOption.createAccount())
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submit() {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    RequestOperationWrapper.executeForegroundRequest(context,
        request: () => ApiClient.sendPostRequest(ApiEndpoint.signIn, _values,
            authenticate: false, readResponseBody: User.fromJson),
        onError: (apiError) => AppUiOverlay().showErrorDialog(
            context, "sign-in",
            info: apiError.message, title: apiError.title),
        onSuccess: (response) {
          AppStorage.saveUserEmail(_values["email"]);
          AppStorage.saveAuthenticationToken((response.body as User).token!);
          AppStorage.saveUserFirstname((response.body as User).firstName);
          AppUiOverlay()
              .showSuccessSnackbarMessage(context, message: "Login successful");
          const HomeScreenRoute().go(context);
        });
  }
}
