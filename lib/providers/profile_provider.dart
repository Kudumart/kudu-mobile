import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kudu/app/locator.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/services/profile_service.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:kudu/core/strings.dart';
import 'package:kudu/data/api/endpoints.dart';
import 'package:kudu/models/get_kyc_model.dart';
import 'package:kudu/models/get_subscription_model.dart';
import 'package:kudu/models/user.dart';
import 'package:kudu/providers/home_provider.dart';
import 'package:kudu/services/payment_key_service.dart';
import 'package:kudu/services/subscription_service.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserDataService _userDataService = locator<UserDataService>();
  final HomeViewModel _homeProvider = locator<HomeViewModel>();
  final PaymentGatewayKeyService _paymentGatewayKeyService =
      locator<PaymentGatewayKeyService>();

  final SubscriptionService _subscriptionService =
      locator<SubscriptionService>();

  String? get firstName => _homeProvider.firstName;
  String? get lastName => _homeProvider.lastName;
  String? get email => _homeProvider.email;
  String? get phoneNumber => _homeProvider.phoneNumber;
  String? get photo => _homeProvider.photo;
  String? get accountType => _homeProvider.accountType;

  GetKycModel _getKycModel = GetKycModel();
  GetKycModel get getKycModel => _getKycModel;

  List<GetSubscriptionModel> _getSubscriptionModel = [];
  List<GetSubscriptionModel> get getSubscriptionModel => _getSubscriptionModel;

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

  Future<void> getKyc({required BuildContext context}) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .get(Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.kyc), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      }).timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        dPrint('profile fetched:::');
        _getKycModel = GetKycModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
        dPrint('profile fetched:::::::');

        print(_getKycModel.data?.businessName);
        // UserModel? user = UserModel.fromJson(
        //     jsonDecode(response.body) as Map<String, dynamic>);

        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
      }
      //failure
      else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();

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

  Future<void> uploadImage({
    required BuildContext context,
    required File? image,
  }) async {
    AppUiOverlay.showLoadingIndicator(context);
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/do2kojulq/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'kudumart'
      ..files.add(await http.MultipartFile.fromPath('file', image!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = json.decode(responseString);
      final imageUrl = jsonMap['url'];
      updateProfilePhoto(context: context, imageUrl: imageUrl);

      notifyListeners();
    } else {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();
      print('Image upload failed');
    }
  }

  Future<void> updateProfilePhoto({
    required BuildContext context,
    required String imageUrl,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .patch(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.profilePhoto),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "photo": imageUrl,
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        fetchUserProfile(context: context);
        AppUiOverlay().showSuccessSnackbarMessage(context,
            message: json.decode(response.body)['message']);
        // AppUiOverlay.dismissLoadingIndicator();
        // notifyListeners();
      }
      //failure
      else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();

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

  Future<void> updatePhoneNumber({
    required BuildContext context,
    required String newPhoneNumber,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .put(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.updatePhoneNumber),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "newPhoneNumber": newPhoneNumber,
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        AppUiOverlay().showSuccessDialog(context, "forgot-password",
            info: jsonDecode(response.body)["message"],
            okayButtonText: "Continue",
            onPressedOkayButton: () => UpdateOTPScreenRoute(
                  isPhoneNumber: true,
                  data: newPhoneNumber,
                ).push(context));
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
      }
      //failure
      else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();

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

  Future<void> updateEmail({
    required BuildContext context,
    required String newEmail,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .put(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.updateEmail),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "newEmail": newEmail,
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        AppUiOverlay().showSuccessDialog(context, "forgot-password",
            info: jsonDecode(response.body)["message"],
            okayButtonText: "Continue",
            onPressedOkayButton: () => UpdateOTPScreenRoute(
                  isPhoneNumber: false,
                  data: newEmail,
                ).push(context));
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
      }
      //failure
      else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();

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

  Future<void> otpUpdateVerification({
    required BuildContext context,
    required String otpCode,
    required String data,
    required bool isPhoneNumber,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .post(
            Uri.parse(
              isPhoneNumber
                  ? ApiEndpoint.baseUrl + ApiEndpoint.verifyUpdatePhoneNumber
                  : ApiEndpoint.baseUrl + ApiEndpoint.verifyUpdateEmail,
            ),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
            body: isPhoneNumber
                ? json.encode(
                    {
                      "newPhoneNumber": data,
                      "otpCode": otpCode,
                    },
                  )
                : json.encode(
                    {
                      "newEmail": data,
                      "otpCode": otpCode,
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
          okayButtonText: "Proceed",
          onPressedOkayButton: () => const EditProfileScreenRoute().go(context),
        );
        // AppUiOverlay().showSuccessDialog(
        //   context,
        //   "otp-verification",
        //   info: jsonDecode(response.body)["message"],
        //   okayButtonText: useForgotPasswordFlow
        //       ? "Reset your password"
        //       : "Proceed to Login",
        //   onPressedOkayButton: () => useForgotPasswordFlow
        //       ? ResetPasswordScreenRoute(otp: otpCode).go(context)
        //       : const SignInScreenRoute().go(context),
        // );
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

  Future<void> updateProfile({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String gender,
    required String country,
    required String state,
    required String city,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .put(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.updateProfile),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "firstName": firstName,
                "lastName": lastName,
                "dateOfBirth": dateOfBirth,
                "gender": gender,
                "location": {
                  "country": country,
                  "state": state,
                  "city": city,
                }
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        fetchUserProfile(context: context);
        AppUiOverlay().showSuccessSnackbarMessage(context,
            message: json.decode(response.body)['message']);
      }
      //failure
      else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();

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
        dPrint('profile fetched:::');
        UserModel? user = UserModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        String fullname = "${user.data?.firstName} ${user.data?.lastName}";

        _userDataService.setUserData = user.data;

        StorageService().addString('name', fullname);
        StorageService().addString('userDetails', jsonEncode(user.data));
        StorageService().addBool('isLoggedIn', true);
        StorageService().addBool('skipOnBoarding', true);
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
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

  Future<void> getSubscription({required BuildContext context}) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      final result = await _subscriptionService.fetchSubscription();
      _getSubscriptionModel = result['data'];

      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();
    } on SocketException {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      // AppUiOverlay()
      //     .showErrorSnackbarMessage(context, message: 'Internet Error');
    } catch (e, x) {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      // AppUiOverlay().showErrorSnackbarMessage(context, message: e.toString());

      dPrint("Error received on fetching subscription: ${e.toString()}");
      print(x);
    }
  }

  Future<void> initatePayment({
    required BuildContext context,
    required double amount,
    required String subscriptionPlanId,
  }) async {
    try {
      final uniqueTransRef = PayWithPayStack().generateUuidV4();

      PayWithPayStack().now(
          context: context,
          secretKey: _paymentGatewayKeyService.paymentKey!.secretKey!,
          customerEmail: _homeProvider.email!,
          reference: uniqueTransRef,
          currency: "NGN",
          amount: amount,
          callbackUrl: "https://google.com",
          transactionCompleted: (paymentData) {
            debugPrint(paymentData.reference);

            makeSubscription(
              context: context,
              subscriptionPlanId: subscriptionPlanId,
              refId: paymentData.reference!,
            );
          },
          transactionNotCompleted: (reason) {
            debugPrint("==> Transaction failed reason $reason");
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> makeSubscription({
    required BuildContext context,
    required String subscriptionPlanId,
    required String refId,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .post(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.makeSubscription),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "subscriptionPlanId": subscriptionPlanId,
                "isWallet": false, // true or false
                "refId": refId,
              },
            ),
          )
          .timeout(const Duration(seconds: 60));
      print('ref id::: ${refId}');
      print('sub id::: ${subscriptionPlanId}');

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        AppUiOverlay().showSuccessDialog(
          context,
          "fetch-profile",
          info: json.decode(response.body)['message'],
        );
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
      }
      //failure
      else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();

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
}
