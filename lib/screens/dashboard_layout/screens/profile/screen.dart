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
import 'package:kudu/screens/authentication/screens/sign_in_screen/screen.dart';
import 'package:provider/provider.dart';

import '../../../../data/storage/shared_preferences.dart';
import '../../../../core/colors.dart';
import '../../../../core/shared_widgets/overlay/overlay.dart';
import '../../../../providers/home_provider.dart';
import '../../../cart/cart.dart';

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
      body: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          return SafeArea(
              minimum: const EdgeInsets.fromLTRB(
                UiConstant.horizontalPadding,
                10,
                UiConstant.horizontalPadding,
                10,
              ),
              child: Column(
                children: [
                  const _EditProfileContainer(),
                  const SizedBox(height: 40),
                  _ProfileItem(
                      label: "My Stores",
                      onPressed: () async {
                        if(Provider.of<HomeViewModel>(context, listen: false).accountType == "Vendor"){
                          const MyStoreScreenRoute().push(context);
                        }else{
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Switch Account'),
                              content: const Text(
                                'Would you like to switch to a vendor account? This will allow you to complete the KYC process.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    var response = await Provider.of<HomeViewModel>(context, listen: false).becomeVendor(context: context);
                                    if(response){
                                      const MyStoreScreenRoute().push(context);
                                      AppUiOverlay().showSuccessSnackbarMessage(context, message: "You are now a vendor");
                                    }
                                  },
                                  child: const Text('Switch to Vendor'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      svgAssetIcon: AppUiIcon.building),
                  const SizedBox(height: 25),
                  const CustomDivider(withoutMargin: true),
                  const SizedBox(height: 25),
                  _ProfileItem(
                      label: Provider.of<HomeViewModel>(context, listen: false).accountType == "Vendor" ? "Update KYC" : "Complete KYC",
                      onPressed: () async {
                        if(Provider.of<HomeViewModel>(context, listen: false).accountType == "Vendor"){
                          const EditKYCScreenRoute().push(context);
                        }else{
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Switch Account'),
                              content: const Text(
                                'Would you like to switch to a vendor account? This will allow you to complete the KYC process.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    var response = await Provider.of<HomeViewModel>(context, listen: false).becomeVendor(context: context);
                                    if(response){
                                      const DoKYCScreenRoute().push(context);
                                      AppUiOverlay().showSuccessSnackbarMessage(context, message: "You are now a vendor, please complete your KYC");
                                    }
                                  },
                                  child: const Text('Switch to Vendor'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      svgAssetIcon: AppUiIcon.kyc),
                  const SizedBox(height: 25),
                  const CustomDivider(withoutMargin: true),
                  const SizedBox(height: 25),
                  _ProfileItem(
                    label: "Cart",
                    onPressed: (){
                      Navigator.of(context,rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    svgAssetIcon: AppUiIcon.cart,
                  ),
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
                      onPressed: () =>
                          const SettingsScreenRoute().push(context),
                      svgAssetIcon: AppUiIcon.settings),
                  const SizedBox(height: 25),
                  const CustomDivider(withoutMargin: true),
                  const SizedBox(height: 25),
                  if (model.accountType == 'Vendor')
                    _ProfileItem(
                      label: "Subscription",
                      onPressed: () => const SubscriptionScreenRoute().push(context),
                      svgAssetIcon: AppUiIcon.subscription,
                    ),
                ],
              ));
        },
      ),
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
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => const SignInScreen(),
      //   ),
      //   (Route<dynamic> route) => false,
      // );
      // const OnboardingScreenRoute().pushReplacement(context);
      const SignInScreenRoute().go(context);
    });
  }
}
