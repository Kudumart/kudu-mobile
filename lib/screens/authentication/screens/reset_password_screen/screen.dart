import 'package:flutter/material.dart';
import 'package:kudu/app/routes/routes.dart';

import '../../../../data/api/endpoints.dart';
import '../../../../data/storage/shared_preferences.dart';
import '../../../../core/constants.dart';
import '../../../../core/images.dart';
import '../../../../core/shared_widgets/back_button.dart';
import '../../../../core/shared_widgets/overlay/overlay.dart';
import '../../../../core/utils/request_operation_wrapper.dart';
import '../../shared_widgets/form_field_title.dart';
import '../../shared_widgets/password_text_form_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String otp;
  const ResetPasswordScreen({required this.otp, super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: AppBackButton(
            onPressed: () => const SignInScreenRoute().go(context),
          ),
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
                const Text("New Password",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                const Text(
                  "Your new password must be different from previously used password",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 35),
                const FormFieldTitle("New Password"),
                PasswordTextFormField(
                  onChanged: (value) => _values["password"] = value,
                  onSaved: (value) => _values["password"] = value,
                ),
                const SizedBox(height: 30),
                const FormFieldTitle("Confirm Password"),
                PasswordTextFormField(
                  onSaved: (value) => _values["confirm_password"] = value,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 38),
                ElevatedButton(
                    onPressed: _submit, child: const Text("Reset my password")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submit() {
    // _formKey.currentState!.save();
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }

    // RequestOperationWrapper.executeForegroundRequest(context,
    //     request: () => ApiClient.sendPostRequest(
    //         ApiEndpoint.resetPassword,
    //         {
    //           "email": AppStorage.userEmail,
    //           "otpCode": widget.otp,
    //           "confirmPassword": _values['confirm_password'],
    //           "newPassword": _values['password']
    //         },
    //         authenticate: false),
    //     onError: (apiError) => AppUiOverlay().showErrorDialog(
    //         context, "reset-password",
    //         info: apiError.message, title: apiError.title),
    //     onSuccess: (response) {
    //       AppUiOverlay().showSuccessDialog(context, "reset-password",
    //           info: response.message,
    //           okayButtonText: "Proceed to Login",
    //           onPressedOkayButton: () => const SignInScreenRoute().go(context));
    //     });
  }

  String? _validateConfirmPassword(String? input) {
    if (input != _values["password"]) {
      return "Passwords do not match";
    }

    return null;
  }
}
