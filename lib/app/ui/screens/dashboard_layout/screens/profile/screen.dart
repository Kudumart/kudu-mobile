import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/ui/constants.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/shared_widgets/divider.dart';

import '../../../../colors.dart';

part 'widgets/edit_profile_container.dart';
part 'widgets/profile_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: false,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: SvgPicture.asset(AppUiIcon.powerButton))
        ],
      ),
      body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 10,
              UiConstant.horizontalPadding, 10),
          child: Column(
            children: [
              const _EditProfileContainer(),
              const SizedBox(height: 40),
              _ProfileItem(
                  label: "My Company",
                  onPressed: () {},
                  svgAssetIcon: AppUiIcon.building),
              const SizedBox(height: 25),
              const CustomDivider(withoutMargin: true),
              const SizedBox(height: 25),
              _ProfileItem(
                  label: "Saved Items",
                  onPressed: () {},
                  svgAssetIcon: AppUiIcon.bookmarkOutline),
              const SizedBox(height: 25),
              const CustomDivider(withoutMargin: true),
              const SizedBox(height: 25),
              _ProfileItem(
                  label: "Recently Viewed",
                  onPressed: () {},
                  svgAssetIcon: AppUiIcon.eye),
              const SizedBox(height: 25),
              const CustomDivider(withoutMargin: true),
              const SizedBox(height: 25),
              _ProfileItem(
                  label: "Settings",
                  onPressed: () => const SettingsScreenRoute().push(context),
                  svgAssetIcon: AppUiIcon.settings),
              const SizedBox(height: 25),
            ],
          )),
    );
  }
}
