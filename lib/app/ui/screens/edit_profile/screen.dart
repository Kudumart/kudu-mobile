import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kudu/app/data/api/client.dart';
import 'package:kudu/app/data/api/endpoints.dart';
import 'package:kudu/app/data/api/model_error.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';
import 'package:kudu/app/ui/shared_widgets/overlay/overlay.dart';

import '../../../models/user_profile.dart';
import '../../constants.dart';
import '../../images.dart';
import '../../shared_widgets/avatar.dart';

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
  late Future<UserProfile>? _fetchUserProfile;
  UserProfile _userProfile = UserProfile(
    firstName: "FirstName",
    lastName: "LastName",
    avatarUrl: "https://picsum.photos/200/300",
    email: "yourname@example.com",
  );

  @override
  void initState() {
    super.initState();
    _fetchUserProfile = _fetchProfile();
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
          child: FutureBuilder<UserProfile>(
            future: _fetchUserProfile,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => AppUiOverlay.showLoadingIndicator(context));
              } else {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => AppUiOverlay.dismissLoadingIndicator());
              }

              if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (snapshot.error is ApiError) {
                    final error = snapshot.error as ApiError;

                    AppUiOverlay().showErrorDialog(context, "user-profile",
                        info: error.message, title: error.title);
                  } else {
                    AppUiOverlay().showErrorDialog(context, "user-profile",
                        info: snapshot.error.toString());
                  }
                });
              }
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => _userProfile = snapshot.data!);
                });
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    UserCircleAvatar(_userProfile.avatarUrl, circleRadius: 50, imageSize: const Size(104, 104)),
                    const SizedBox(height: 10),
                    const _EditButton(),
                    const SizedBox(height: 33),
                    _FormFields(_userProfile),
                    const SizedBox(height: 21),
                    const _CompleteKYCContainer()
                  ],
                ),
              );
            },
          ),
        ));
  }

  Future<UserProfile> _fetchProfile() async {
    final response = await ApiClient.sendGetRequest(ApiEndpoint.userProfile,
        authenticate: true);
    return UserProfile.fromJson(response.body as Map<String, dynamic>);
  }
}
