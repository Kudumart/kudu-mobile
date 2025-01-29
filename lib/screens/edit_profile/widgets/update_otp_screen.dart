import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kudu/data/storage/shared_preferences.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/providers/auth_viewmodel.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:kudu/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../data/api/endpoints.dart';
import '../../../../core/constants.dart';
import '../../../../core/images.dart';
import '../../../../core/shared_widgets/overlay/overlay.dart';
import '../../../../core/utils/request_operation_wrapper.dart';

part 'pin_fields.dart';

class UpdateOTPScreen extends StatefulWidget {
  final bool isPhoneNumber;
  final String data;

  const UpdateOTPScreen({
    this.isPhoneNumber = true,
    super.key,
    required this.data,
  });

  @override
  State<UpdateOTPScreen> createState() => _UpdateOTPScreenState();
}

class _UpdateOTPScreenState extends State<UpdateOTPScreen> {
  String? _code;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the verification code sent to the ${widget.isPhoneNumber ? 'phone number' : 'email'} provided",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 27),
              Form(
                  key: _formKey,
                  child: _OTPInput(
                    onChanged: (input) {
                      _code = input;
                    },
                    onCompleted: (input) {
                      _code = input;
                      _submit();
                    },
                  )),
              const SizedBox(height: 30),
              // const _ResendPrompt(),
              const SizedBox(height: 22),
              ElevatedButton(onPressed: _submit, child: const Text("Verify")),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Provider.of<ProfileViewModel>(context, listen: false).otpUpdateVerification(
      context: context,
      otpCode: _code!,
      data: widget.data,
      isPhoneNumber: widget.isPhoneNumber,
    );
  }
}
