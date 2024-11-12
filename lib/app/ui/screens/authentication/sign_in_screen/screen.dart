import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/data/input_validators.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/custom_text_form_field.dart';
import 'package:kudu/app/ui/screens/authentication/shared_widgets/terms_and_conditions_statement.dart';

import '../../../images.dart';
import '../shared_widgets/form_field_title.dart';
import '../shared_widgets/password_text_form_field.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Login to your Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
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
                      onTap: () => const ForgotPasswordScreenRoute().push(context),
                      child: const Text("Forgot your password?",
                          style: TextStyle(
                              color: AppColor.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500))),
                ),
                  
                // terms and conditions
                const SizedBox(height: 33),
                const TermsAndConditionsStatement(),
                const SizedBox(height: 24),
                  
                // login button
                ElevatedButton(onPressed: _saveValues, child: const Text("Login")),
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

  _saveValues() {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }
}
