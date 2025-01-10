import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/services/profile_service.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/core/shared_widgets/divider.dart';
import 'package:kudu/screens/authentication/screens/sign_in_screen/screen.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppUiColor.grey50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          forceMaterialTransparency: true,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 40,
                UiConstant.horizontalPadding, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("General",
                      style: TextStyle(
                          fontSize: 16.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 30),
                  _Item(
                      label: "Security and Privacy",
                      onPressed: () =>
                          const SecurityAndPrivacyScreenRoute().push(context),
                      svgAssetIcon: AppUiIcon.security),
                  const SizedBox(height: 40),
                  _Item(
                      label: "Notifications",
                      showTrailingIcon: false,
                      onPressed: () {
                        const NotificationsScreenRoute().push(context);
                      },
                      svgAssetIcon: AppUiIcon.bell),
                  const SizedBox(height: 40),
                  _Item(
                      label: "Preferences",
                      onPressed: () {
                        // const PreferencesScreenRoute().push(context);
                      },
                      svgAssetIcon: AppUiIcon.filter),
                  const SizedBox(height: 40),
                  _Item(
                      label: "Help and Support",
                      onPressed: () {
                        // const HelpAndSupportScreenRoute().push(context);
                      },
                      svgAssetIcon: AppUiIcon.info),
                  const SizedBox(height: 40),
                  _Item(
                      label: "Logout",
                      onPressed: () {},
                      svgAssetIcon: AppUiIcon.logout),
                  const SizedBox(height: 40),
                  _Item(
                      label: "Delete Account",
                      onPressed: () {
                        StorageService().removeBool('isLoggedIn');
                        StorageService().removeString('userDetails');
                        StorageService().removeString('showBalance');

                        // //StorageService().removeString('pin');
                        // //StorageService().removeBool('token');
                        // //StorageService().removeBool('skipOnBoarding');
                        UserDataService().clearUserData();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                            (Route<dynamic> route) => false);
                      },
                      svgAssetIcon: AppUiIcon.trashCan),
                  const SizedBox(height: 25),
                  const CustomDivider(withoutMargin: true),
                  const SizedBox(height: 40),
                  const Text("Feedback",
                      style: TextStyle(
                          fontSize: 16.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 25),
                  _Item(
                      label: "Send Feedback",
                      onPressed: () {},
                      showTrailingIcon: false,
                      svgAssetIcon: AppUiIcon.star)
                ],
              ),
            )));
  }
}

class _Item extends StatelessWidget {
  final String svgAssetIcon;
  final String label;
  final Function() onPressed;
  final bool showTrailingIcon;
  const _Item(
      {required this.label,
      required this.onPressed,
      this.showTrailingIcon = true,
      required this.svgAssetIcon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          SvgPicture.asset(svgAssetIcon,
              height: 20,
              width: 20,
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
            ),
          ),
          if (showTrailingIcon)
            const Icon(CupertinoIcons.chevron_forward,
                size: 16, color: Color(0xFF808080))
        ],
      ),
    );
  }
}
