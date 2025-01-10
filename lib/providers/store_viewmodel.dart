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
import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/models/user.dart';
import 'package:kudu/services/currency_service.dart';
import 'package:kudu/services/store_service.dart';

class StoreViewModel extends ChangeNotifier {
  // final UserDataService _userService = locator<UserDataService>();
  final CurrencyService _currenciesService = locator<CurrencyService>();
  final StoreService _storeService = locator<StoreService>();

  List<GetStoreModel> _getStoreModel = [];
  List<GetStoreModel> get getStoreModel => _getStoreModel;

  List<CurrencyData>? get currencies => _currenciesService.currencies;

  Future<void> uploadImage({
    required BuildContext context,
    required File? image,
    required String storeId,
    required String storeName,
    required String address,
    required String city,
    required String state,
    required String country,
    required String businessHoursMF,
    required String businessHoursSAT,
    required String businessHoursSUN,
    required String currencyId,
    required List<Map<String, dynamic>> deliveryOption,
    required String tipsOnFinding,
  }) async {
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
      updateStore(
        context: context,
        storeId: storeId,
        storeName: storeName,
        address: address,
        city: city,
        state: state,
        country: country,
        businessHoursMF: businessHoursMF,
        businessHoursSAT: businessHoursSAT,
        businessHoursSUN: businessHoursSUN,
        currencyId: currencyId,
        deliveryOption: deliveryOption,
        tipsOnFinding: tipsOnFinding,
        logo: imageUrl,
      );
      print(imageUrl);
      notifyListeners();
      print('Image uploaded successfully');
    } else {
      print('Image upload failed');
    }
  }

  Future<void> createStore({
    required BuildContext context,
    required String storeName,
    required String address,
    required String city,
    required String state,
    required String country,
    required String businessHoursMF,
    required String businessHoursSAT,
    required String businessHoursSUN,
    required String currencyId,
    required List<Map<String, dynamic>> deliveryOption,
    required String tipsOnFinding,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);

      notifyListeners();

      var response = await http
          .post(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.store),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "currencyId": currencyId,
                "name": storeName,
                "location": {
                  "address": address,
                  "city": city,
                  "state": state,
                  "country": country
                },
                "businessHours": {
                  "monday_friday": businessHoursMF,
                  "saturday": businessHoursSAT,
                  "sunday": businessHoursSUN
                },
                "deliveryOptions": deliveryOption,
                "tipsOnFinding": tipsOnFinding,
                "logo": ""
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
          message: 'Store created successfully',
        );
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

  Future<void> updateStore({
    required BuildContext context,
    required String storeId,
    required String storeName,
    required String address,
    required String city,
    required String state,
    required String country,
    required String businessHoursMF,
    required String businessHoursSAT,
    required String businessHoursSUN,
    required String currencyId,
    required List<Map<String, dynamic>> deliveryOption,
    required String tipsOnFinding,
    required String logo,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .put(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.store),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "storeId": storeId,
                "currencyId": currencyId,
                "name": storeName,
                "location": {
                  "address": address,
                  "city": city,
                  "state": state,
                  "country": country
                },
                "businessHours": {
                  "monday_friday": businessHoursMF,
                  "saturday": businessHoursSAT,
                  "sunday": businessHoursSUN
                },
                "deliveryOptions": deliveryOption,
                "tipsOnFinding": tipsOnFinding,
                "logo": logo
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        const MyStoreScreenRoute().pushReplacement(context);

        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: 'Store Updated successfully',
        );
        notifyListeners();
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
}
