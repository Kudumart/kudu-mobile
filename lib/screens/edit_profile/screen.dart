import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kudu/app/locator.dart';
import 'package:kudu/core/services/profile_service.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/data/api/model_error.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:kudu/models/user.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:kudu/screens/edit_profile/widgets/country_data.dart';
import 'package:provider/provider.dart';

import '../../models/enums_and_extensions.dart';
import '../../models/user_profile.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/avatar.dart';

part 'widgets/new_email_screen.dart';

part 'widgets/edit_button.dart';
part 'widgets/custom_text_field.dart';
part 'widgets/form_fields.dart';
part 'widgets/phone_number_field.dart';
part 'widgets/complete_kyc_container.dart';
part 'widgets/dob_container.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Future<UserData> _fetchUserProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile = _loadUserProfile();
  }

  Future<UserData> _loadUserProfile() async {
    try {
      final UserDataService userDataService = locator<UserDataService>();

      var decodedData =
          jsonDecode('${StorageService().getString('userDetails')}');

      return userDataService.setUserData =
          UserData.fromJson(decodedData as Map<String, dynamic>);
    } catch (e) {
      throw ApiError(
        title: "Failed to Load Profile",
        message: e.toString(),
      );
    }
  }

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
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          UiConstant.horizontalPadding,
          30,
          UiConstant.horizontalPadding,
          10,
        ),
        child: FutureBuilder<UserData>(
          future: _fetchUserProfile,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => AppUiOverlay.showLoadingIndicator(context),
              );
              return const SizedBox(); // Placeholder while waiting
            } else {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => AppUiOverlay.dismissLoadingIndicator(),
              );
            }

            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (snapshot.error is ApiError) {
                  final error = snapshot.error as ApiError;

                  AppUiOverlay().showErrorDialog(
                    context,
                    "user-profile",
                    info: error.message,
                    title: error.title,
                  );
                } else {
                  AppUiOverlay().showErrorDialog(
                    context,
                    "user-profile",
                    info: snapshot.error.toString(),
                  );
                }
              });
              return const Center(
                child: Text("Failed to load user profile."),
              );
            }

            if (snapshot.hasData) {
              final userProfile = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        UserCircleAvatar(
                          userProfile.photo,
                          circleRadius: 50,
                          imageSize: const Size(104, 104),
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.camera_alt,
                            color: AppUiColor.primary,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 33),
                    _FormFields(userProfile),
                    const SizedBox(height: 21),
                    if (!userProfile.isVerified!)
                      _CompleteKYCContainer(
                        userProfile: userProfile,
                      ),
                  ],
                ),
              );
            }

            return const Center(
              child: Text("No data available."),
            );
          },
        ),
      ),
    );
  }
}
