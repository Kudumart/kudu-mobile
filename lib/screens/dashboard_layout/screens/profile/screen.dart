import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/services/profile_service.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/core/shared_widgets/avatar.dart';
import 'package:kudu/core/shared_widgets/divider.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../../data/storage/shared_preferences.dart';
import '../../../../core/colors.dart';
import '../../../../core/shared_widgets/overlay/overlay.dart';

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
              onPressed: () => _logout(context),
              icon: SvgPicture.asset(AppUiIcon.powerButton))
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
                  label: "My Stores",
                  onPressed: () => const MyStoreScreenRoute().push(context),
                  svgAssetIcon: AppUiIcon.building),
              const SizedBox(height: 25),
              const CustomDivider(withoutMargin: true),
              const SizedBox(height: 25),
              _ProfileItem(
                  label: "Update KYC",
                  onPressed: () => const EditKYCScreenRoute().push(context),
                  svgAssetIcon: AppUiIcon.kyc),
              const SizedBox(height: 25),
              const CustomDivider(withoutMargin: true),
              const SizedBox(height: 25),
              _ProfileItem(
                  label: "Bookmarked Items",
                  onPressed: () =>
                      const BookmarkedProductsScreenRoute().push(context),
                  svgAssetIcon: AppUiIcon.bookmarkOutline),
              const SizedBox(height: 25),
              const CustomDivider(withoutMargin: true),
              const SizedBox(height: 25),
              _ProfileItem(
                  label: "Settings",
                  onPressed: () => const SettingsScreenRoute().push(context),
                  svgAssetIcon: AppUiIcon.settings),
              const SizedBox(height: 25),
              const CustomDivider(withoutMargin: true),
              const SizedBox(height: 25),
              _ProfileItem(
                  label: "Subscription",
                  onPressed: () =>
                      const SubscriptionScreenRoute().push(context),
                  svgAssetIcon: AppUiIcon.subscription),
            ],
          )),
    );
  }

  _logout(BuildContext context) {
    AppUiOverlay().showActionDialog(context, "logout",
        title: "Confirm Logout",
        info: "Are you sure you want to logout?",
        okayButtonText: "Logout", onPressedOkayButton: () {
      StorageService().removeBool('isLoggedIn');
      StorageService().removeString('userDetails');
      StorageService().removeString('showBalance');
      UserDataService().clearUserData();
      const SignInScreenRoute().go(context);
    });
  }
}
