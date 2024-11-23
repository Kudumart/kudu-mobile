import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kudu/app/data/api/client.dart';
import 'package:kudu/app/data/api/endpoints.dart';
import 'package:kudu/app/data/storage/shared_preferences.dart';
import 'package:kudu/app/ui/shared_widgets/overlay/overlay.dart';
import 'package:kudu/app/ui/utils/input_validators.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/custom_text_form_field.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/terms_and_conditions_statement.dart';
import 'package:kudu/app/ui/utils/request_operation_wrapper.dart';

import '../../../../colors.dart';
import '../../../../constants.dart';
import '../../../../images.dart';
import '../../../../shared_widgets/back_button.dart';
import '../../shared_widgets/form_field_title.dart';
import '../../shared_widgets/password_text_form_field.dart';

part 'widgets/intl_phone_number_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
          minimum: EdgeInsets.fromLTRB(
              UiConstant.horizontalPadding,
              40,
              UiConstant.horizontalPadding,
              MediaQuery.of(context).viewInsets.bottom + 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Create a Kudu Account",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  const Text(
                    "One last step before continuing to app",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 26),

                  // email
                  const FormFieldTitle("Email"),
                  CustomTextFormField(
                    onSaved: (value) => _values["email"] = value,
                    hint: "Enter email",
                    validator: InputValidator.validateEmail,
                  ),
                  const SizedBox(height: 23),

                  // password
                  const FormFieldTitle("Password"),
                  PasswordTextFormField(
                    onSaved: (value) => _values["password"] = value,
                  ),
                  const SizedBox(height: 23),

                  // first name
                  const FormFieldTitle("First Name"),
                  CustomTextFormField(
                    validator: InputValidator.validateValidInput,
                    hint: "Enter first name",
                    onSaved: (value) => _values["firstName"] = value,
                  ),
                  const SizedBox(height: 23),

                  const FormFieldTitle("Last Name"),
                  CustomTextFormField(
                    validator: InputValidator.validateValidInput,
                    hint: "Enter last name",
                    onSaved: (value) => _values["lastName"] = value,
                  ),
                  const SizedBox(height: 23),

                  // phone
                  const FormFieldTitle("Phone"),
                  _IntlPhoneNumberField(
                      onSaved: (number) =>
                          _values["phoneNumber"] = number?.completeNumber),
                  const SizedBox(height: 25),

                  // terms and condition
                  const TermsAndConditionsStatement(),
                  const SizedBox(height: 24),

                  ElevatedButton(
                      onPressed: _saveValues,
                      child: const Text("Create my Kudu Account")),
                  const SizedBox(height: 32),
                  // login
                  const Center(child: AlternateAuthOption.login()),
                  const SizedBox(height: 12),
                  Center(
                      child: GestureDetector(
                          onTap: () => const ReAskVerificationCodeScreenRoute()
                              .push(context),
                          child: const Text(
                            "Or Verify your Email",
                            style: TextStyle(
                                color: AppUiColor.iconBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                decorationColor: Colors.grey,
                                decoration: TextDecoration.underline),
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveValues() async {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    RequestOperationWrapper.executeForegroundRequest(context,
        request: () => ApiClient.sendPostRequest(ApiEndpoint.signUp, _values,
            authenticate: false),
        onError: (apiError) => AppUiOverlay().showErrorDialog(
            context, "sign-up",
            info: apiError.message, title: apiError.title),
        onSuccess: (response) {
          AppStorage.saveUserEmail(_values["email"]);
          AppUiOverlay().showSuccessDialog(context, "sign-up",
              info: response.message,
              onPressedOkayButton: () =>
                  const VerifyOTPScreenRoute(useForgotPasswordFlow: false)
                      .push(context));
        });
  }
}
