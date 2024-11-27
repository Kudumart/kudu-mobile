import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';

import '../../constants.dart';
import '../../images.dart';

part 'widgets/edit_button.dart';
part 'widgets/custom_text_field.dart';
part 'widgets/form_fields.dart';
part 'widgets/phone_number_field.dart';
part 'widgets/complete_kyc_container.dart';
part 'widgets/dob_container.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("Edit Profile",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          forceMaterialTransparency: true,
          actions: [
            TextButton(
                onPressed: () {},
                child: const Text("Save",
                    style: TextStyle(fontSize: 14, color: AppUiColor.textBlue)))
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 30,
              UiConstant.horizontalPadding, 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  foregroundImage: Image.asset(
                    AppUiImage.userAvatar,
                    height: 104,
                    width: 104,
                  ).image,
                ),
                const SizedBox(height: 10),
                const _EditButton(),
                const SizedBox(height: 33),
                const _FormFields(),
                const SizedBox(height: 21),
                const _CompleteKYCContainer()
              ],
            ),
          ),
        ));
  }
}
