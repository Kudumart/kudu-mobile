import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/data/input_validators.dart';
import 'package:kudu/app/ui/routes/routes.dart';

import '../../../../images.dart';
import '../../shared_widgets/alternate_auth_option.dart';
import '../../shared_widgets/custom_text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(18, 25, 0, 0),
            child: GestureDetector(
              onTap: context.pop,
              child: const Text("Cancel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          centerTitle: true,
          title: Image.asset(UiImage.kuduLogo,
              width: 82, height: 27, fit: BoxFit.cover),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(18, 40, 18, 20),
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
                  validator: InputValidator.validateEmailOrPhone,
                  onSaved: (value) => _values["email_or_phone"] = value,
                  hint: "Email or phone number",
                ),
                const SizedBox(height: 36),

                // login button
                ElevatedButton(
                    onPressed: () => _saveValues(context),
                    child: const Text("Continue")),
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

  _saveValues(BuildContext context) {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    const ForgotPasswordOTPScreenRoute().push(context);
  }
}
