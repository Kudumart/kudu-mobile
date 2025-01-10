import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kudu/app/locator.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/services/profile_service.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:kudu/core/strings.dart';
import 'package:kudu/data/api/endpoints.dart';
import 'package:kudu/providers/home_provider.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserDataService _userDataService = locator<UserDataService>();
  final HomeViewModel _homeProvider = locator<HomeViewModel>();

  String? get firstName => _homeProvider.firstName;
  String? get lastName => _homeProvider.lastName;
  String? get email => _homeProvider.email;
  String? get phoneNumber => _homeProvider.phoneNumber;
  String? get photo => _homeProvider.photo;

  Future<void> submitKyc({
    required BuildContext context,
    required String businessName,
    required String contactEmail,
    required String contactPhoneNumber,
    required String businessDescription,
    required String businessLink,
    required String businessAddress,
    required String businessRegistrationNumber,
    required String ninNumber,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .post(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.kyc),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "businessName": businessName,
                "contactEmail": contactEmail,
                "contactPhoneNumber": contactPhoneNumber,
                "businessDescription": businessDescription,
                "businessLink": businessLink,
                "businessAddress": businessAddress,
                "businessRegistrationNumber": businessRegistrationNumber,
                "idVerification": {
                  "name": "NIN",
                  "number": ninNumber,
                }
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        notifyListeners();
        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: 'Kyc Submitted Successfully',
        );
        Navigator.pop(context);
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorSnackbarMessage(
          context,
          message: json.decode(response.body)['message'].toString(),
        );
        // print(json.decode(response.body)['message'].toString());

        dPrint('error ${response.body}');
      }
    } on SocketException {
      AppUiOverlay.dismissLoadingIndicator();

      notifyListeners();
      AppUiOverlay().showErrorDialog(
        context,
        "kyc",
        info: AppStrings.internetError,
        title: 'Internet Error',
      );
      // Fluttertoast.showToast(
      //   msg: AppStrings.internetError,
      //   backgroundColor: AppColor().red,
      //   textColor: AppColor().white,
      // );
    } catch (e, x) {
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorDialog(
        context,
        "kyc",
        info: AppStrings.unknownError,
        title: 'Unknown Error',
      );
      notifyListeners();

      dPrint("Error creating kyc: ${e.toString()}");
      dPrint("Error creating kyc: ${x.toString()}");
    }
  }
}
