import 'package:flutter/material.dart';
import 'package:kudu/core/utils/input_validators.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:kudu/providers/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../data/api/endpoints.dart';
import '../../../../data/storage/shared_preferences.dart';
import '../../../../core/constants.dart';
import '../../../../core/images.dart';
import '../../../../core/shared_widgets/overlay/overlay.dart';
import '../../../../core/utils/request_operation_wrapper.dart';
import '../../shared_widgets/alternate_auth_option.dart';
import '../../shared_widgets/custom_filled_text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                const Text("Forgot Password?",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                const Text(
                  "Enter the email address or phone number associated with your account to change your password",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 27),

                CustomTextFormField(
                  validator: InputValidator.validateEmail,
                  textEditingController: _emailController,
                  hint: "Enter your email",
                ),
                const SizedBox(height: 36),

                // login button
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    Provider.of<AuthViewmodel>(context, listen: false)
                        .forgotPassword(
                      context: context,
                      email: _emailController.text,
                    );
                  },
                  child: const Text("Continue"),
                ),
                const SizedBox(height: 28),

                // alt auth option
                const Align(
                    alignment: Alignment.center,
                    child: AlternateAuthOption.loginOnForgotPassword())
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _submit() {
  //   _formKey.currentState!.save();
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   RequestOperationWrapper.executeForegroundRequest(context,
  //       request: () => ApiClient.sendPostRequest(
  //           ApiEndpoint.forgotPassword, _values, authenticate: false),
  //       onError: (apiError) => AppUiOverlay().showErrorDialog(
  //           context, "forgot-password",
  //           info: apiError.message, title: apiError.title),
  //       onSuccess: (response) {
  //         AppStorage.saveUserEmail(_values["email"]);
  //         AppUiOverlay().showSuccessDialog(context, "forgot-password",
  //             info: response.message,
  //             okayButtonText: "Continue",
  //             onPressedOkayButton: () =>
  //                 const VerifyOTPScreenRoute().push(context));
  //       });
  // }
}
