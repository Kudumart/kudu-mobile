import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kudu/app/locator.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/constants.dart';
import 'dart:developer' as dev;

import 'package:kudu/core/services/profile_service.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:kudu/core/strings.dart';
import 'package:kudu/data/api/endpoints.dart';
import 'package:kudu/data/api/model_error.dart';
import 'package:kudu/models/currency_model.dart';
import 'package:kudu/models/user.dart';
import 'package:kudu/services/currency_service.dart';

class AuthViewmodel extends ChangeNotifier {
  final UserDataService _userService = locator<UserDataService>();
  final CurrencyService _currenciesService = locator<CurrencyService>();

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);

      notifyListeners();

      var response = await http
          .post(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.signIn),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
            body: json.encode(
              {
                'email': email.trim(),
                'password': password.trim(),
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        dPrint('login successful:::');
        StorageService()
            .addString('token', jsonDecode(response.body)['data']['token']);
        fetchUserProfile(context: context);

        notifyListeners();
        AppUiOverlay.dismissLoadingIndicator();
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        // print(json.decode(response.body)['message'].toString());
        if (response.statusCode == ApiError.unverifiedEmail().statusCode) {
          AppUiOverlay().showErrorDialog(context, "unverified-email",
              info: json.decode(response.body)['message'].toString(),
              okayButtonText: "Verify Email",
              onPressedOkayButton: () =>
                  const ReAskVerificationCodeScreenRoute().push(context),
              title: 'Unverified Email');
        } else {
          AppUiOverlay().showErrorDialog(
            context,
            "sign-in",
            info: json.decode(response.body)['message'].toString(),
            title: 'Error',
          );
        }

        dPrint('error ${response.body}');
      }
    } on SocketException {
      AppUiOverlay.dismissLoadingIndicator();

      notifyListeners();
      AppUiOverlay().showErrorDialog(
        context,
        "sign-in",
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
      notifyListeners();
      AppUiOverlay().showErrorDialog(
        context,
        "sign-in",
        info: AppStrings.unknownError,
        title: 'Unknown Error',
      );

      dPrint("Error received on login: ${e.toString()}");
      dPrint("Error received on login: ${x.toString()}");
    }
  }

  Future<void> fetchUserProfile({required BuildContext context}) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http.get(
          Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.userProfile),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer ${StorageService().getString('token')}'
          }).timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        print(StorageService().getString('token'));

        dPrint('profile fetched:::');
        UserModel? user = UserModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        String fullname = "${user.data?.firstName} ${user.data?.lastName}";

        _userService.setUserData = user.data;

        StorageService().addString('name', fullname);
        StorageService().addString('userDetails', jsonEncode(user.data));
        StorageService().addBool('isLoggedIn', true);
        StorageService().addBool('skipOnBoarding', true);
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        fetchCurrency(context);
        // fetchWallets(context);
      }
      //failure
      else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();

        // Fluttertoast.showToast(
        //   msg: json.decode(response.body)['message'] ?? AppStrings.unknownError,
        //   backgroundColor: AppColor().red,
        //   textColor: AppColor().white,
        // );
        if (response.body == "Unauthorized") {
          const WelcomeScreen2Route();
          return;
        }
        AppUiOverlay().showErrorDialog(
          context,
          "fetch-profile",
          info:
              json.decode(response.body)['message'] ?? AppStrings.unknownError,
          title: 'Error',
        );

        dPrint('error1 ${response.body}');
      }
    } on SocketException {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      AppUiOverlay().showErrorDialog(
        context,
        "fetch-profile",
        info: AppStrings.internetError,
        title: 'Internet Error',
      );
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      AppUiOverlay().showErrorDialog(
        context,
        "fetch-profile",
        info: AppStrings.unknownError,
        title: 'Unknown Error',
      );

      dPrint("Error received on fetching profile: ${e.toString()}");
    }
  }

  Future<void> fetchCurrency(BuildContext context) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .get(Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.currency), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      }).timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        dPrint('currency fetched:::');
        CurrencyModel? temp = CurrencyModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        _currenciesService.setCurrencies = temp.data;

        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();

        const HomeScreenRoute().go(context);

        // UserModel? user = UserModel.fromJson(
        //     jsonDecode(response.body) as Map<String, dynamic>);
        // String fullname = "${user.data?.firstName} ${user.data?.lastName}";
      }
      //failure
      else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
      }
    } on SocketException {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      AppUiOverlay().showErrorDialog(
        context,
        "fetch-currency",
        info: AppStrings.internetError,
        title: 'Internet Error',
      );
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      AppUiOverlay().showErrorDialog(
        context,
        "fetch-currency",
        info: AppStrings.unknownError,
        title: 'Unknown Error',
      );

      dPrint("Error received on fetching profile: ${e.toString()}");
    }
  }
}
