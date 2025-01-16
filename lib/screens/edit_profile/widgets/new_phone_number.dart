import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:kudu/screens/edit_profile/screen.dart';
import 'package:provider/provider.dart';

class NewPhoneNumber extends StatefulWidget {
  const NewPhoneNumber({super.key});

  @override
  State<NewPhoneNumber> createState() => _NewPhoneNumberState();
}

class _NewPhoneNumberState extends State<NewPhoneNumber> {
  final formKey = GlobalKey<FormState>();
  String? phoneNumber;
  bool isValidPhoneNumber = false;

  void updatePhoneNumberValidity(PhoneNumber number) {
    setState(() {
      // Remove any non-digit characters and check length
      final digitsOnly = number.number?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
      isValidPhoneNumber = digitsOnly.length >= 10;
      phoneNumber = number.completeNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const AppBackButton(),
        titleSpacing: 0,
        title: const Text("Change Phone Number",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: false,
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          UiConstant.horizontalPadding,
          30,
          UiConstant.horizontalPadding,
          10,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                IntlPhoneNumberField(
                  hintText: "New phone number",
                  initialCompletePhoneNumber: phoneNumber,
                  onSaved: (phoneNum) {
                    if (phoneNum != null) {
                      phoneNumber = phoneNum.completeNumber;
                    }
                  },
                  onChanged: updatePhoneNumberValidity,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValidPhoneNumber
                        ? AppUiColor.primary
                        : AppUiColor.buttonFillGrey200,
                    disabledBackgroundColor: AppUiColor.buttonFillGrey200,
                    disabledForegroundColor: Colors.grey[600],
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                  ),
                  onPressed: isValidPhoneNumber
                      ? () {
                          if (formKey.currentState!.validate()) {
                            Provider.of<ProfileViewModel>(context,
                                    listen: false)
                                .updatePhoneNumber(
                              context: context,
                              newPhoneNumber: phoneNumber!,
                            );
                            // Handle the saved phone number
                          }
                        }
                      : null,
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          isValidPhoneNumber ? Colors.white : Colors.grey[600],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
