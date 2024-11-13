import 'package:flutter/material.dart';
import 'package:kudu/app/ui/routes/routes.dart';

import '../../../../images.dart';
import '../../shared_widgets/form_field_title.dart';
import '../../shared_widgets/password_text_form_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

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
          backgroundColor: Colors.white,
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(18, 25, 0, 0),
            child: GestureDetector(
              onTap: () => const SignInScreenRoute().go(context),
              child: const Text("Back",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          centerTitle: true,
          title: Image.asset(AppImage.kuduLogo,
              width: 82, height: 27, fit: BoxFit.cover),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(18, 40, 18, 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("New Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                const Text(
                  "Your new password must be different from previously used password",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 35),
                const FormFieldTitle("New Password"),
                PasswordTextFormField(
                  onSaved: (value) => _values["password"] = value,
                ),
                const SizedBox(height: 30),
                const FormFieldTitle("Confirm Password"),
                PasswordTextFormField(
                  onSaved: (value) => _values["confirm_password"] = value,
                  invalidInputValidatorText: "Passwords do not match",
                ),
                const SizedBox(height: 38),
                ElevatedButton(
                    onPressed: _saveValues, child: const Text("Reset my password")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveValues() {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }
}
