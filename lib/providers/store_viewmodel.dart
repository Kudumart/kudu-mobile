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
import 'package:kudu/models/get_categories_model.dart';
import 'package:kudu/models/get_product_model.dart';
import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/models/user.dart';
import 'package:kudu/services/currency_service.dart';
import 'package:kudu/services/store_service.dart';
import 'package:provider/provider.dart';

import 'home_provider.dart';

class StoreViewModel extends ChangeNotifier {
  // final UserDataService _userService = locator<UserDataService>();
  final CurrencyService _currenciesService = locator<CurrencyService>();
  final StoreService _storeService = locator<StoreService>();

  List<GetCategoriesModel> _getcategoriesModel = [];
  List<GetCategoriesModel> get getcategoriesModel => _getcategoriesModel;

  List<GetProductModel> _getproductsModel = [];
  List<GetProductModel> get getproductsModel => _getproductsModel;

  List<CurrencyData>? get currencies => _currenciesService.currencies;

  Future<void> fetchCurrency(BuildContext context) async {
    try {
      var response = await http.get(Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.currency), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      }).timeout(const Duration(seconds: 60));

      //success
      if (response.statusCode == 200) {
        CurrencyModel? temp = CurrencyModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        _currenciesService.setCurrencies = temp.data;

        //AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
      }
      //failure
      else {
        //AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
      }
    } on SocketException {
      //AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> getCategories({required BuildContext context}) async {
    try {
      final result = await _storeService.fetchCategories();
      _getcategoriesModel = result['data'];
      notifyListeners();
    } catch (e) {
      dev.log(e.toString());
    }
  }

  // Future<void> getVendorsProducts({required BuildContext context}) async {
  //   try {

  //     final result = await _storeService.fetchVendorsProducts();
  //     _getproductsModel = result['data'];
  //     notifyListeners();
  //   } catch (e) {
  //     dev.log(e.toString());
  //   }
  // }

  Future<void> getVendorsProducts({required BuildContext context}) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      final result = await _storeService.fetchVendorsProducts();
      final auctionResult = await _storeService.fetchVendorsAuctionProducts();

      var normalList = result['data'] ?? [];
      var auctionList = auctionResult['data'] ?? [];
      _getproductsModel = [...normalList, ...auctionList];

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

      dPrint("Error received on fetching Product: ${e.toString()}");
      print(x);
    }
  }

  Future<void> deleteProduct({
    required BuildContext context,
    required String productId,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http.delete(
        Uri.parse(
            '${ApiEndpoint.baseUrl}${ApiEndpoint.product}?productId=$productId'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${StorageService().getString('token')}'
        },
      ).timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      if (response.statusCode == 200) {
        // Remove the deleted product from the list
        _getproductsModel.removeWhere((product) => product.id == productId);

        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: 'Product deleted successfully',
        );
        notifyListeners();
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorSnackbarMessage(
          context,
          message: json.decode(response.body)['message'].toString(),
        );
        dPrint('error ${response.body}');
      }
    } on SocketException {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();
      AppUiOverlay().showErrorDialog(
        context,
        "delete-product",
        info: AppStrings.internetError,
        title: 'Internet Error',
      );
    } catch (e, x) {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();
      AppUiOverlay().showErrorDialog(
        context,
        "delete-product",
        info: AppStrings.unknownError,
        title: 'Unknown Error',
      );

      dPrint("Error received on delete product: ${e.toString()}");
      dPrint("Error stack trace: ${x.toString()}");
    }
  }

  Future<void> deleteAuctionProduct({
    required BuildContext context,
    required String productId,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http.delete(
        Uri.parse('${ApiEndpoint.baseUrl}${ApiEndpoint.auctionProduct}?auctionProductId=$productId'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${StorageService().getString('token')}'
        },
      ).timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      if (response.statusCode == 200) {
        // Remove the deleted product from the list
        _getproductsModel.removeWhere((product) => product.id == productId);

        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: 'Product deleted successfully',
        );
        notifyListeners();
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorSnackbarMessage(
          context,
          message: json.decode(response.body)['message'].toString(),
        );
        dPrint('error ${response.body}');
      }
    } on SocketException {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();
      AppUiOverlay().showErrorDialog(
        context,
        "delete-product",
        info: AppStrings.internetError,
        title: 'Internet Error',
      );
    } catch (e, x) {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();
      AppUiOverlay().showErrorDialog(
        context,
        "delete-product",
        info: AppStrings.unknownError,
        title: 'Unknown Error',
      );

      dPrint("Error received on delete product: ${e.toString()}");
      dPrint("Error stack trace: ${x.toString()}");
    }
  }

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

  Future<bool> createStore({
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
        //const MyStoreScreenRoute().pushReplacement(context);
        await Provider.of<HomeViewModel>(context, listen: false).getStores(
          context: context,
          isLoading: false,
        );
        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: 'Store created successfully',
        );
        notifyListeners();
        return true;
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
    return false;
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

  Future<bool> addProductToStore({
    required BuildContext context,
    required String storeId,
    required String categoryId,
    required String productName,
    required String condition,
    required String description,
    required String specification,
    required String price,
    required String discountPrice,
    required String imageUrl,
    required List<String> additionalImages,
    required String warranty,
    required String returnPolicy,
    required String seoTitle,
    required String metaDescription,
    required String keywords,
    required String quantity,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var additionalImagesData = [...additionalImages];
      var response = await http
          .post(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.product),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "storeId": storeId,
                "categoryId": categoryId,
                "name": productName,
                "condition": condition,
                "description": description,
                "specification": specification,
                "price": price,
                "discount_price": discountPrice,
                "image_url": imageUrl,
                "additional_images": additionalImagesData,
                "warranty": warranty,
                "return_policy": returnPolicy,
                "seo_title": seoTitle,
                "meta_description": metaDescription,
                "keywords": keywords,
                "quantity": quantity,
              },
            ),
          ).timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: json.decode(response.body)['message'].toString(),
        );
        //StoreProductsScreenRoute(GetStoreModel()).pushReplacement(context);

        notifyListeners();
        return true;
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorDialog(
          context,"create-product",
          title: 'Error',
          info: json.decode(response.body)['message'].toString(),
        );
        // print(json.decode(response.body)['message'].toString());

        dPrint('error ${response.body}');
        return false;
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
    return false;
  }

  Future<bool> addAuctionProductToStore({
    required BuildContext context,
    required String storeId,
    required String categoryId,
    required String productName,
    required String condition,
    required String description,
    required String specification,
    required String price,
    required String imageUrl,
    required List<String> additionalImages,
    required String maxBidsPerUser,
    required String auctionStartDate,
    required String auctionEndDate,
    required String participantsInterestFee,
    required String bidIncrement,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var additionalImagesData = [...additionalImages];
      var response = await http
          .post(
        Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.auctionProduct),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${StorageService().getString('token')}'
        },
        body: json.encode({
          "storeId": storeId,
          "categoryId": categoryId,
          "name": productName,
          "condition": condition,
          "description": description,
          "specification": specification,
          "price": price,
          "image": imageUrl,
          "additionalImages": additionalImagesData,

          "bidIncrement": bidIncrement,
          "maxBidsPerUser": maxBidsPerUser,
          "startDate": auctionStartDate,
          "endDate": auctionEndDate,
          "participantsInterestFee": participantsInterestFee,
        },
        ),
      ).timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: json.decode(response.body)['message'].toString(),
        );
        //StoreProductsScreenRoute(GetStoreModel()).pushReplacement(context);

        notifyListeners();
        return true;
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorDialog(
          context,"create-product",
          title: 'Error',
          info: json.decode(response.body)['message'].toString(),
        );
        // print(json.decode(response.body)['message'].toString());

        dPrint('error ${response.body}');
        return false;
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
    return false;
  }

  Future<bool> updateProduct({
    required BuildContext context,
    required String productId,
    required String categoryId,
    required String productName,
    required String condition,
    required String description,
    required String specification,
    required String price,
    required String discountPrice,
    required String imageUrl,
    required List<String> additionalImages,
    required String warranty,
    required String returnPolicy,
    required String seoTitle,
    required String metaDescription,
    required String keywords,
    required String quantity,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http
          .put(
            Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.product),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer ${StorageService().getString('token')}'
            },
            body: json.encode(
              {
                "productId": productId,
                "categoryId": categoryId,
                "name": productName,
                "condition": condition,
                "description": description,
                "specification": specification,
                "price": price,
                "discount_price": discountPrice,
                "image_url": imageUrl,
                "additional_images": additionalImages,
                "warranty": warranty,
                "return_policy": returnPolicy,
                "seo_title": seoTitle,
                "meta_description": metaDescription,
                "keywords": keywords,
                "quantity": quantity,
              },
            ),
          )
          .timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: json.decode(response.body)['message'].toString(),
        );
        //StoreProductsScreenRoute(GetStoreModel()).pushReplacement(context);

        notifyListeners();
        return true;
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
    return false;
  }

  Future<bool> updateActionProduct({
    required BuildContext context,
    required String productId,
    required String storeId,
    required String categoryId,
    required String productName,
    required String condition,
    required String description,
    required String specification,
    required String price,
    required String imageUrl,
    required List<String> additionalImages,
    required String maxBidsPerUser,
    required String auctionStartDate,
    required String auctionEndDate,
    required String participantsInterestFee,
    required String bidIncrement,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var additionalImagesData = [...additionalImages];
      var response = await http
          .put(
        Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.auctionProduct),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${StorageService().getString('token')}'
        },
        body: json.encode({
          "auctionProductId": productId,
          "storeId": storeId,
          "categoryId": categoryId,
          "name": productName,
          "condition": condition,
          "description": description,
          "specification": specification,
          "price": price,
          "image": imageUrl,
          "additionalImages": additionalImagesData,
          "bidIncrement": bidIncrement,
          "maxBidsPerUser": maxBidsPerUser,
          "startDate": auctionStartDate,
          "endDate": auctionEndDate,
          "participantsInterestFee": participantsInterestFee,
        },
        ),
      ).timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: json.decode(response.body)['message'].toString(),
        );
        //StoreProductsScreenRoute(GetStoreModel()).pushReplacement(context);

        notifyListeners();
        return true;
      } else {
        AppUiOverlay.dismissLoadingIndicator();
        notifyListeners();
        AppUiOverlay().showErrorDialog(
          context,"create-product",
          title: 'Error',
          info: json.decode(response.body)['message'].toString(),
        );
        // print(json.decode(response.body)['message'].toString());

        dPrint('error ${response.body}');
        return false;
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
    return false;
  }
}
