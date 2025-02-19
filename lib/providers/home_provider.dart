import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kudu/app/locator.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/services/profile_service.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:kudu/core/strings.dart';
import 'package:kudu/data/api/endpoints.dart';
import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/models/payment_key_model.dart';
import 'package:kudu/models/user.dart';
import 'package:kudu/services/payment_key_service.dart';
import 'package:kudu/services/store_service.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../models/home/categories_model.dart';
import '../models/home/products_list_model.dart';

class HomeViewModel extends ChangeNotifier {
  final UserDataService _userDataService = locator<UserDataService>();
  final PaymentGatewayKeyService _paymentGatewayKeyService = locator<PaymentGatewayKeyService>();

  final StoreService _storeService = locator<StoreService>();

  List<GetStoreModel> _getStoreModel = [];
  List<GetStoreModel> get getStoreModel => _getStoreModel;

  String? get firstName => _userDataService.userData?.firstName;
  String? get lastName => _userDataService.userData?.lastName;
  String? get email => _userDataService.userData?.email;
  String? get phoneNumber => _userDataService.userData?.phoneNumber;
  String? get photo => _userDataService.userData?.photo;
  bool? get isVerified => _userDataService.userData?.isVerified;
  String? get accountType => _userDataService.userData?.accountType;

  final storageService = StorageService();
  String get token{
    return 'Bearer ${storageService.getString('token')}';
  }

  // HomeViewModel() {
  //   setup();
  // }

  // String? get photo => _userDataService.userData?.photo;

  // RefreshController refreshController =
  //     RefreshController(initialRefresh: false);

  void setup() async {
    var decodedData = await jsonDecode('${StorageService().getString('userDetails')}');
    if (decodedData != null) {
      _userDataService.setUserData = UserData.fromJson(decodedData as Map<String, dynamic>);
      getPaymentKey();
    }

    // UserData.fromJson(decodedData as Map<String, dynamic>);
  }

  Future<void> refresh(BuildContext context) async {
    await getStores(context: context, isLoading: false);
    // await _storeViewModel.getStores(context);
    // await fetchWallets(context);
    // await fetchTransactions(context);
    // refreshController.refreshCompleted();
  }

  Future<void> getStores({required BuildContext context, required bool isLoading}) async {
    try {
      if (isLoading) {
        AppUiOverlay.showLoadingIndicator(context);
        notifyListeners();
        // return;
      }

      final result = await _storeService.fetchStores();
      _getStoreModel = result['data'];

      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();
    } on SocketException {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      // AppUiOverlay()
      //     .showErrorSnackbarMessage(context, message: 'Internet Error');
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      // AppUiOverlay().showErrorSnackbarMessage(context, message: e.toString());

      dPrint("Error received on fetching profile: ${e.toString()}");
    }
  }

  Future<void> deleteStore({required BuildContext context, required String storeId}) async {
    try {
      // print( )
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http.delete(
        Uri.parse(
            '${ApiEndpoint.baseUrl + ApiEndpoint.store}' + '?storeId=$storeId'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${StorageService().getString('token')}'
        },
      ).timeout(const Duration(seconds: 60));

      dPrint('statusCode::: ${response.statusCode}');
      dPrint('response::: ${response.body}');

      //success
      if (response.statusCode == 200) {
        const MyStoreScreenRoute().pushReplacement(context);

        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showSuccessSnackbarMessage(
          context,
          message: 'Store Deleted successfully',
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

  Future<void> fetchCurrency(BuildContext context) async {
    try {
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

  Future<void> getPaymentKey() async {
    try {
      var response = await http.get(
          Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.paymentKey),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer ${StorageService().getString('token')}'
          }).timeout(const Duration(seconds: 60));

      //success
      if (response.statusCode == 200) {
        PaymentGatewayKeyModel? paymentGatewayKeyModel = PaymentGatewayKeyModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        _paymentGatewayKeyService.setPaymentKey = paymentGatewayKeyModel.data;
      }
      //failure
      else {
        dPrint('error1 ${response.body}');
      }
    } on SocketException {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      dPrint("Error received on fetching profile: ${e.toString()}");
    }
  }

  String searchValue = "";

  CategoriesModel? _categoriesModel;
  CategoriesModel? get categoriesModel => _categoriesModel;
  Future<CategoriesModel?> fetchCategories({required BuildContext context,bool force = false,bool showLoader = false}) async {
    if (_categoriesModel != null && !force) {
      return _categoriesModel;
    }
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/categories/with/sub-categories"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        CategoriesModel responseData = CategoriesModel.fromJson(data);
        _categoriesModel = responseData;
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(_){
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return null;
      }
    } else {
      if(showLoader){
        AppUiOverlay.dismissLoadingIndicator();
      }
      return null;
    }
  }

  ProductsListModel? _productsListModel;
  Future<ProductsListModel?> fetchAllProducts({required BuildContext context,bool showLoader = false,bool force = false,String? search}) async {
    if(_productsListModel != null && !force){
      return _productsListModel;
    }
   if(showLoader){
     AppUiOverlay.showLoadingIndicator(context);
   }
   var url = "${ApiEndpoint.baseUrl}/api/products";
   if((search ?? "").trim().isNotEmpty){
     url += "?name=${search ?? ""}";
   }

    var response = await http.get(Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        ProductsListModel responseData = ProductsListModel.fromJson(data);
        _productsListModel = responseData;
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(_){

      }
    }
    if(showLoader){
      AppUiOverlay.dismissLoadingIndicator();
    }
   return null;
  }

  final Map<String,ProductsListModel> _productsWithCategoryId = {};
  Future<ProductsListModel?> fetchProductsByCategory({required BuildContext context,required String categoryId,bool force = false,String? search}) async {
    if(_productsWithCategoryId[categoryId] != null && !force){
      return _productsWithCategoryId[categoryId];
    }
    AppUiOverlay.showLoadingIndicator(context);

    var url = "${ApiEndpoint.baseUrl}/api/products?categoryId=$categoryId";
    if((search ?? "").trim().isNotEmpty){
      url += "&name=${search ?? ""}";
    }
    var response = await http.get(Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        ProductsListModel responseData = ProductsListModel.fromJson(data);
        _productsWithCategoryId[categoryId] = responseData;

        AppUiOverlay.dismissLoadingIndicator();
        return responseData;
      }catch(e){
        AppUiOverlay.dismissLoadingIndicator();
        return null;
      }
    } else {
      AppUiOverlay.dismissLoadingIndicator();
      return null;
    }
  }

  final Map<String,ProductsListModel> _productsWithCondition = {};
  Future<ProductsListModel?> fetchProductsByCondition({required BuildContext context,required String condition,bool force = false,String? search}) async {
    if(_productsWithCondition[condition] != null && !force){
      return _productsWithCondition[condition];
    }
    AppUiOverlay.showLoadingIndicator(context);

    var url = "${ApiEndpoint.baseUrl}/api/products?condition=$condition";
    if((search ?? "").trim().isNotEmpty){
      url += "&name=${search ?? ""}";
    }
    var response = await http.get(Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        ProductsListModel responseData = ProductsListModel.fromJson(data);
        _productsWithCondition[condition] = responseData;

        AppUiOverlay.dismissLoadingIndicator();
        return responseData;
      }catch(e){
        AppUiOverlay.dismissLoadingIndicator();
        return null;
      }
    } else {
      AppUiOverlay.dismissLoadingIndicator();
      return null;
    }
  }

  final Map<String,ProductsListModel> _productsWithSubCategory = {};
  Future<ProductsListModel?> fetchProductsBySubCategory({required BuildContext context,required String subCategory,bool force = false,String? search}) async {
    if(_productsWithSubCategory[subCategory] != null && !force){
      return _productsWithSubCategory[subCategory];
    }
    AppUiOverlay.showLoadingIndicator(context);

    var url = "${ApiEndpoint.baseUrl}/api/products?subCategoryName=$subCategory";
    if((search ?? "").trim().isNotEmpty){
      url += "&name=${search ?? ""}";
    }
    var response = await http.get(Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        ProductsListModel responseData = ProductsListModel.fromJson(data);
        _productsWithSubCategory[subCategory] = responseData;

        AppUiOverlay.dismissLoadingIndicator();
        return responseData;
      }catch(e){
        AppUiOverlay.dismissLoadingIndicator();
        return null;
      }
    } else {
      AppUiOverlay.dismissLoadingIndicator();
      return null;
    }
  }

  Future<ProductData?> fetchProduct({required BuildContext context,required String productId}) async {
    AppUiOverlay.showLoadingIndicator(context);
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/product?productId=$productId"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        List<ProductData>? recommendedProducts = [];
        if(data['recommendedProducts'] != null){
          recommendedProducts = data['recommendedProducts'].map<ProductData>((v) => ProductData.fromJson(v)).toList();
        }

        ProductData responseData = ProductData.fromJson(data['data']);
        responseData.recommendedProducts = recommendedProducts;

        AppUiOverlay.dismissLoadingIndicator();
        return responseData;
      }catch(_){
        AppUiOverlay.dismissLoadingIndicator();
        return null;
      }
    } else {
      AppUiOverlay.dismissLoadingIndicator();
      return null;
    }
  }

  Future<bool> becomeVendor({required BuildContext context}) async{
    if(_userDataService.userData?.accountType == "Vendor"){
      return true;
    }
    AppUiOverlay.showLoadingIndicator(context);
    try{
      var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/user/become/vendor"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
      );

      AppUiOverlay.dismissLoadingIndicator();
      if (response.statusCode == 200 || response.statusCode == 201) {
        _userDataService.userData?.accountType = "Vendor";
        StorageService().addString('userDetails', jsonEncode(_userDataService.userData));
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        if(message == "User is already a vendor"){
          _userDataService.userData?.accountType = "Vendor";
          StorageService().addString('userDetails', jsonEncode(_userDataService.userData));
          AppUiOverlay().showErrorSnackbarMessage(context, message: "You are already a vendor");
        }else{
          AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
        }
      }
    }catch(_){
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }

  // Future<void> refreshHome(BuildContext context) async {
  //   await fetchUserProfile(context: context);
  // }

  List<ListenableServiceMixin> get listenableServices => [_userDataService];
}
