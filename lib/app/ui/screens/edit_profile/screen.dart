import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kudu/app/data/api/client.dart';
import 'package:kudu/app/data/api/endpoints.dart';
import 'package:kudu/app/data/api/model_error.dart';
import 'package:kudu/app/data/storage/shared_preferences.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';
import 'package:kudu/app/ui/shared_widgets/overlay/overlay.dart';

import '../../../models/enums_and_extensions.dart';
import '../../../models/user.dart';
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
  UserProfile _userProfile = UserProfile(
    firstName: "",
    lastName: "",
    userType: UserType.customer,
    avatarUrl: "https://picsum.photos/200/300",
    email: "",
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchProfile());
  }

  Future<void> fetchProfile() async {
    AppUiOverlay.showLoadingIndicator(context);
    var response = await _fetchProfile();
    if(response != null){
      _userProfile = response;
    }
    AppUiOverlay.dismissLoadingIndicator();
    setState(() {

    });
  }

  Future<void> updateProfile() async {
    AppUiOverlay.showLoadingIndicator(context);
    await _updateProfile();
    AppUiOverlay.dismissLoadingIndicator();
    setState(() {

    });
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
                onPressed: () {
                  updateProfile();
                },
                child: const Text("Save",
                    style: TextStyle(fontSize: 14, color: AppUiColor.textBlue)))
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 30, UiConstant.horizontalPadding, 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserCircleAvatar(_userProfile.avatarUrl, circleRadius: 50, imageSize: const Size(104, 104)),
                const SizedBox(height: 10),
                const _EditButton(),
                const SizedBox(height: 33),
                _FormFields(_userProfile,key: UniqueKey()),
                const SizedBox(height: 21),
                const _CompleteKYCContainer()
              ],
            ),
          ),
        ),
    );
  }

  Future<UserProfile?> _fetchProfile() async {
    try{
      final response = await ApiClient.sendGetRequest(ApiEndpoint.userProfile, authenticate: true);
      if (response.body is! Map<String, dynamic>) {
        return null;
      }
      return UserProfile.fromJson(response.body as Map<String, dynamic>);
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<UserProfile?> _updateProfile() async {
    try{
      var body = {
        "firstName": _userProfile.firstName,
        "lastName": _userProfile.lastName,
        "dateOfBirth": _userProfile.dateOfBirth,
      };

      var body2 = {
        "newPhoneNumber": (_userProfile.phoneNumber ?? "").startsWith("+") ? (_userProfile.phoneNumber ?? ""): "+${_userProfile.phoneNumber ?? ""}",
      };

      final response = await ApiClient.sendPutRequest(ApiEndpoint.updateProfile,body, authenticate: true);
      final response2 = await ApiClient.sendPutRequest(ApiEndpoint.updatePhone,body2, authenticate: true);
      if (response.body is! Map<String, dynamic>) {
        return null;
      }
      var responseObj = UserProfile.fromJson(response.body as Map<String, dynamic>);
      if(AppStorage.user != null){
        AppStorage.saveUser(AppStorage.user!.copyWith(
          firstName: _userProfile.firstName,
          lastName: _userProfile.lastName,
          dateOfBirth: _userProfile.dateOfBirth,
          phoneNumber: _userProfile.phoneNumber,
        ));
      }else{
        AppStorage.saveUser(User(
          firstName: _userProfile.firstName,
          lastName: _userProfile.lastName,
          dateOfBirth: _userProfile.dateOfBirth,
          isVerified: false,
          phoneNumber: _userProfile.phoneNumber ?? "",
        ));
      }
      return responseObj;
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
