import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/app/routes/routes.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';

part 'widgets/change_password_container.dart';
part 'widgets/privacy_and_terms.dart';

class SecurityAndPrivacyScreen extends StatelessWidget {
  const SecurityAndPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppUiColor.grey50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("Security and Privacy",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          forceMaterialTransparency: true,
        ),
        body: const SafeArea(
            minimum: EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 0, UiConstant.horizontalPadding, 10),
            child: Column(
              children: [
                /*_ChangePasswordContainer(),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Update your security and login details. Kindly note that haring any information from this page may compromise your account",
                    style: TextStyle(color: Color(0xFF808080)),
                  ),
                ),*/
                //SizedBox(height: 30),
                _PrivacyAndTermsOfService(),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Get to know rules that bind our organization and understand your rights on the Kudu app",
                    style: TextStyle(color: Color(0xFF808080)),
                  ),
                ),
              ],
            )));
  }
}
