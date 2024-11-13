import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/data/input_validators.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/custom_text_form_field.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/terms_and_conditions_statement.dart';

import '../../../../images.dart';
import '../../shared_widgets/form_field_title.dart';
import '../../shared_widgets/password_text_form_field.dart';

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
          title: Image.asset(AppImage.kuduLogo,
              width: 82, height: 27, fit: BoxFit.cover),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(18, 40, 18, 20),
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

                  // full name
                  const FormFieldTitle("Full Name"),
                  CustomTextFormField(
                    hint: "Enter full name",
                    onSaved: (value) => _values["full_name"] = value,
                  ),
                  const SizedBox(height: 23),

                  // phone
                  const FormFieldTitle("Phone"),
                  CustomTextFormField(
                    hint: "Enter phone number",
                    onSaved: (value) => _values["phone"] = value,
                  ),
                  const SizedBox(height: 25),

                  // terms and condition
                  const TermsAndConditionsStatement(),
                  const SizedBox(height: 24),

                  ElevatedButton(
                      onPressed: _saveValues,
                      child: const Text("Create my Kudu Account")),
                  const SizedBox(height: 32),
                  // login
                  const Center(child: AlternateAuthOption.login())
                ],
              ),
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
