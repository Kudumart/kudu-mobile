import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/models/user.dart';
import 'package:kudu/screens/dashboard_layout/dashboard_layout.dart';
import 'package:kudu/screens/dashboard_layout/screens/home/screen.dart';
import 'package:kudu/services/currency_service.dart';

class AuthViewmodel extends ChangeNotifier {
  final UserDataService _userService = locator<UserDataService>();
  final CurrencyService _currenciesService = locator<CurrencyService>();

  Future<void> registerWithEmail({
    required BuildContext context,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required UserType userType,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .post(
            Uri.parse(
              userType == UserType.vendor
                  ? ApiEndpoint.baseUrl + ApiEndpoint.signUpAsVendor
                  : ApiEndpoint.baseUrl + ApiEndpoint.signUpAsCustomer,
            ),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
            body: json.encode({
              "email": email.trim(),
              "password": password.trim(),
              "firstName": firstName.trim(),
              "lastName": lastName.trim(),
              "phoneNumber": phoneNumber.trim(),
            }),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        dPrint('user registered:::');
        StorageService().addString('email', email.trim());
        const VerifyOTPScreenRoute(useForgotPasswordFlow: false).push(context);

        notifyListeners();
        AppUiOverlay.dismissLoadingIndicator();
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showErrorDialog(
          context,
          "sign-up",
          info: jsonDecode(response.body)["message"],
          title: "Server Exception",
        );
        // AppUiOverlay.showSnackBar(
        //     context, jsonDecode(response.body)["message"]);
      }
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorDialog(
        context,
        "sign-up",
        info: e.toString(),
        title: "Client Exception",
      );
    }
  }

  Future<void> forgotPassword(
      {required BuildContext context, required String email}) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .post(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.forgotPassword),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
            body: json.encode(
              {
                'email': email.trim(),
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        StorageService().addString('email', email.trim());
        AppUiOverlay().showSuccessDialog(context, "forgot-password",
            info: jsonDecode(response.body)["message"],
            okayButtonText: "Continue",
            onPressedOkayButton: () =>
                const VerifyOTPScreenRoute().push(context));

        notifyListeners();
        AppUiOverlay.dismissLoadingIndicator();
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorDialog(
          context,
          "forgot-password",
          info: jsonDecode(response.body)["message"],
          title: "Server Exception",
        );
      }
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorDialog(
        context,
        "forgot-password",
        info: e.toString(),
        title: "Client Exception",
      );
    }
  }

  Future<void> resendVerificationEmail({required BuildContext context}) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .post(
            Uri.parse(
                ApiEndpoint.baseUrl + ApiEndpoint.resendVerificationEmail),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
            body: json.encode(
              {
                'email': StorageService().getString('email'),
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        // AppUiOverlay().showSuccessDialog(
        //   context,
        //   "resend-verification-email",
        //   info: jsonDecode(response.body)["message"],
        //   okayButtonText: "Continue",
        //   onPressedOkayButton: () =>
        //       const VerifyOTPScreenRoute(useForgotPasswordFlow: false)
        //           .push(context),
        // );

        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: 'OTP resent successfully',
        );

        notifyListeners();
        AppUiOverlay.dismissLoadingIndicator();
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorDialog(
          context,
          "resend-verification-email",
          info: jsonDecode(response.body)["message"],
          title: "Server Exception",
        );
      }
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorDialog(
        context,
        "resend-verification-email",
        info: e.toString(),
        title: "Client Exception",
      );
    }
  }

  Future<void> otpVerification({
    required BuildContext context,
    required String otpCode,
    required bool useForgotPasswordFlow,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .post(
            Uri.parse(
              useForgotPasswordFlow
                  ? ApiEndpoint.baseUrl + ApiEndpoint.verifyForgotPasswordOTP
                  : ApiEndpoint.baseUrl + ApiEndpoint.verifyEmail,
            ),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
            body: json.encode(
              {
                'email': StorageService().getString('email'),
                'otpCode': otpCode.trim(),
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        AppUiOverlay().showSuccessDialog(
          context,
          "otp-verification",
          info: jsonDecode(response.body)["message"],
          okayButtonText: useForgotPasswordFlow
              ? "Reset your password"
              : "Proceed to Login",
          onPressedOkayButton: () => useForgotPasswordFlow
              ? ResetPasswordScreenRoute(otp: otpCode).go(context)
              : const SignInScreenRoute().go(context),
        );
        notifyListeners();
        AppUiOverlay.dismissLoadingIndicator();
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorDialog(
          context,
          "sign-up",
          info: jsonDecode(response.body)["message"],
          title: "Server Exception",
        );
      }
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorDialog(
        context,
        "sign-up",
        info: e.toString(),
        title: "Client Exception",
      );
    }
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .post(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.resetPassword),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
            body: json.encode(
              {
                "email": StorageService().getString('email'),
                "otpCode": otpCode,
                "confirmPassword": confirmPassword,
                "newPassword": newPassword,
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        AppUiOverlay().showSuccessDialog(
          context,
          "reset-password",
          info: jsonDecode(response.body)["message"],
          okayButtonText: "Proceed to Login",
          onPressedOkayButton: () => const SignInScreenRoute().go(context),
        );
        notifyListeners();
        AppUiOverlay.dismissLoadingIndicator();
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorDialog(
          context,
          "sign-up",
          info: jsonDecode(response.body)["message"],
          title: "Server Exception",
        );
      }
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorDialog(
        context,
        "sign-up",
        info: e.toString(),
        title: "Client Exception",
      );
    }
  }

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
        // AppUiOverlay.dismissLoadingIndicator();
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        // print(json.decode(response.body)['message'].toString());
        if (response.statusCode == ApiError.unverifiedEmail().statusCode) {
          StorageService().addString('email', email.trim());
          AppUiOverlay().showErrorDialog(
            context,
            "unverified-email",
            info: json.decode(response.body)['message'].toString(),
            okayButtonText: "Verify Email",
            onPressedOkayButton: () =>
                const VerifyOTPScreenRoute(useForgotPasswordFlow: false)
                    .push(context),
            title: 'Unverified Email',
          );
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

        if (user.data!.accountType == "Customer") {
          AppUiOverlay.dismissLoadingIndicator();
          notifyListeners();
          const HomeScreenRoute().go(context);
          return;
        }

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
        if (json.decode(response.body)['message'] == "Unauthorized") {
          const OnboardingScreenRoute().pushReplacement(context);
        } else {
          AppUiOverlay().showErrorDialog(
            context,
            "fetch-profile",
            info: json.decode(response.body)['message'] ??
                AppStrings.unknownError,
            title: 'Error',
          );
        }

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
        //
        if (context.mounted) {
          context.go('/home', extra: {'refresh': true});
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const HomeScreen(),
          //     settings: const RouteSettings(name: '/home'),
          //   ),
          //   (route) => false, // This will clear the entire stack
          // );
        }

        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();

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
