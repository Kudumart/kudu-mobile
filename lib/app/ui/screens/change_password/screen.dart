import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../constants.dart';
import '../../shared_widgets/back_button.dart';

part 'widgets/password_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("Change Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          forceMaterialTransparency: true,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 48,
                UiConstant.horizontalPadding, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FieldTitle("Current Password"),
                const SizedBox(height: 8),
                const _PasswordTextFormField(hint: "Enter current password"),
                const SizedBox(height: 23),
                const _FieldTitle("New Password"),
                const SizedBox(height: 8),
                const _PasswordTextFormField(hint: "Enter new password"),
                const SizedBox(height: 23),
                const _FieldTitle("Confirm Password"),
                const SizedBox(height: 8),
                const _PasswordTextFormField(hint: "Confirm new password"),
                const SizedBox(height: 23),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                    onPressed: () {}, child: const Text("Change Password"))
              ],
            )));
  }
}

class _FieldTitle extends StatelessWidget {
  final String name;
  const _FieldTitle(this.name);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    );
  }
}
