import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kudu/app/locator.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/extensions.dart';
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
import 'package:pay_with_paystack/model/payment_data.dart' as paystackData;
import 'package:pay_with_paystack/pay_with_paystack.dart' as paystack;
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../models/advert/advert_model.dart';
import '../models/home/cart_list_model.dart';
import '../models/home/categories_model.dart';
import '../models/home/customer_order_details.dart';
import '../models/home/location_model.dart';
import '../models/home/notifications_model.dart';
import '../models/home/order_details.dart';
import '../models/home/order_list_data.dart';
import '../models/home/products_list_model.dart';
import 'package:http_parser/http_parser.dart';

import '../models/jobs/job_details_model.dart';
import '../models/reviews/review_models.dart';

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
  UserData? get userData => _userDataService.userData;
  void setUserData(UserData? val) {
    _userDataService.setUserData = val;
  }

  final storageService = StorageService();
  String get token{
    return 'Bearer ${storageService.getString('token')}';
  }
  bool isLoggedIn = StorageService().getBool('isLoggedIn') ?? false;


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
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
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
  Future<ProductsListModel?> fetchAllProducts({required BuildContext context,bool showLoader = false,bool force = false,String? search,bool isPopular = false}) async {
    if(_productsListModel != null && !force){
      return _productsListModel;
    }
   if(showLoader){
     AppUiOverlay.showLoadingIndicator(context);
   }
   var url = "${ApiEndpoint.baseUrl}/api/products";
   if((search ?? "").trim().isNotEmpty){
     url += "?name=${search ?? ""}";
     if(isPopular){
       url += "&popular=true";
     }
   }else{
     if(isPopular){
        url += "?popular=true";
     }
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
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }
    }
    if(showLoader){
      AppUiOverlay.dismissLoadingIndicator();
    }
   return null;
  }

  final Map<String,ProductsListModel> _productsWithCategoryId = {};
  Future<ProductsListModel?> fetchProductsByCategory({required BuildContext context,required String categoryId,bool force = false,String? search,bool isPopular = false}) async {
    if(_productsWithCategoryId[categoryId] != null && !force){
      return _productsWithCategoryId[categoryId];
    }
    AppUiOverlay.showLoadingIndicator(context);

    var url = "${ApiEndpoint.baseUrl}/api/products?categoryId=$categoryId";
    if((search ?? "").trim().isNotEmpty){
      url += "&name=${search ?? ""}";
      if(isPopular){
        url += "&popular=true";
      }
    }else{
      if(isPopular){
        url += "&popular=true";
      }
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
  Future<ProductsListModel?> fetchProductsByCondition({required BuildContext context,required String condition,bool force = false,String? search,bool isPopular = false}) async {
    if(_productsWithCondition[condition] != null && !force){
      return _productsWithCondition[condition];
    }
    AppUiOverlay.showLoadingIndicator(context);

    var url = "${ApiEndpoint.baseUrl}/api/products?condition=$condition";
    if((search ?? "").trim().isNotEmpty){
      url += "&name=${search ?? ""}";
      if(isPopular){
        url += "&popular=true";
      }
    }else{
      if(isPopular){
        url += "&popular=true";
      }
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
  Future<ProductsListModel?> fetchProductsBySubCategory({required BuildContext context,required String subCategory,bool force = false,String? search,bool isPopular = false}) async {
    if(_productsWithSubCategory[subCategory] != null && !force){
      return _productsWithSubCategory[subCategory];
    }
    AppUiOverlay.showLoadingIndicator(context);

    var url = "${ApiEndpoint.baseUrl}/api/products?subCategoryName=$subCategory";
    if((search ?? "").trim().isNotEmpty){
      url += "&name=${search ?? ""}";
      if(isPopular){
        url += "&popular=true";
      }
    }else{
      if(isPopular){
        url += "&popular=true";
      }
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

  ProductsListModel? _auctionProductsListModel;
  Future<ProductsListModel?> fetchAllAuctionProducts({
    required BuildContext context,
    bool showLoader = false,
    bool force = false,
    bool save = true,

    String? name,
    String? storeId,
    String? subCategoryName,
    String? condition,
    String? limit,
    String? offset,
    String? startDate,
    String? auctionStatus,
  }) async {
    if(_auctionProductsListModel != null && !force && save){
      return _auctionProductsListModel;
    }
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }

    var url = "${ApiEndpoint.baseUrl}/api/auction/products".addParamsToUrl({
      "name": name,
      "storeId": storeId,
      "subCategoryName": subCategoryName,
      "condition": condition,
      "limit": limit,
      "offset": offset,
      "startDate": startDate,
      "auctionStatus": auctionStatus,
    });
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
        if(save){
          _auctionProductsListModel = responseData;
        }
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }
    }
    if(showLoader){
      AppUiOverlay.dismissLoadingIndicator();
    }
    return null;
  }

  CartListModel? _savedProducts;
  Future<CartListModel?> fetchSavedProducts({required BuildContext context,bool showLoader = true}) async {
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var url = "${ApiEndpoint.baseUrl}/api/user/saved/products";
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
        CartListModel responseData = CartListModel.fromJson(data);
        _savedProducts = responseData;
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }
    }
    if(showLoader){
      AppUiOverlay.dismissLoadingIndicator();
    }
    return null;
  }
  bool isInBookmarks(String productId){
    if(_savedProducts == null){
      return false;
    }
    return (_savedProducts?.data ?? []).any((element) => element.productId == productId) ?? false;
  }
  Future<void> updateBookMarks({required BuildContext context}) async {
    if((_savedProducts?.data ?? []).isEmpty){
      await fetchSavedProducts(context:context,showLoader: false);
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
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
        AppUiOverlay.dismissLoadingIndicator();
        return null;
      }
    } else {
      AppUiOverlay.dismissLoadingIndicator();
      return null;
    }
  }

  Future<NotificationsModel?> fetchNotifications() async {
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/user/notifications"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        NotificationsModel responseData = NotificationsModel.fromJson(data);
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
        return null;
      }
    } else {
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
          AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }

  Future<List<String>?> uploadImages({required List<String> images,MediaType? fileType}) async{
    if(images.isEmpty){
      return [];
    }
    try{
      List<String> listToReturn = [];

      await Future.forEach(images, (image) async {
        var url = Uri.parse("${ApiEndpoint.baseUrl}/api/upload/file");
        var request = http.MultipartRequest("POST", url);
        request.headers.addAll({
          "Accept": "application/json",
          'Authorization': token,
        });
        var multiPartFile = await http.MultipartFile.fromPath('image', image, contentType: fileType ?? MediaType('image', 'jpeg'));
        request.files.add(multiPartFile);
        var response = await request.send();
        if (response.statusCode == 200 || response.statusCode == 201) {
          final respStr = await response.stream.bytesToString();
          var imageUrl = (jsonDecode(respStr))["data"];
          if(imageUrl is String){
            listToReturn.add(imageUrl);
          }
          return true;
        }else{
        }
      });
      return listToReturn;
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<JobDetailsModel>?> fetchAllJobs({required BuildContext context}) async {
    AppUiOverlay.showLoadingIndicator(context);
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/fetch/jobs"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      AppUiOverlay.dismissLoadingIndicator();
      try{
        final dataFromApi = json.decode(response.body);
        final dataList = dataFromApi['data'] as List;
        List<JobDetailsModel> responseData = dataList.map<JobDetailsModel>((v) => JobDetailsModel.fromJson(v)).toList();
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
        AppUiOverlay.dismissLoadingIndicator();
        return null;
      }
    } else {
      AppUiOverlay.dismissLoadingIndicator();
      return null;
    }
  }

  Future<bool> applyToJob({required BuildContext context,required String jobId,required String name,required String emailAddress,required String phoneNumber,required File resume}) async{
    AppUiOverlay.showLoadingIndicator(context);
    try{
      var uploadedFilesUrl = await uploadImages(images: [resume.path],fileType: MediaType('application', 'pdf'));
      if(uploadedFilesUrl == null || uploadedFilesUrl.isEmpty){
        AppUiOverlay.dismissLoadingIndicator();
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Unable to upload resume, please try again later");
        return false;
      }
      var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/apply/job"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "jobId": jobId,
          "name": name,
          "emailAddress": emailAddress,
          "phoneNumber": phoneNumber,
          "resumeType": "pdf",
          "resume": (uploadedFilesUrl ?? [])[0],
        }),
      );

      AppUiOverlay.dismissLoadingIndicator();
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop();
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Application submitted successfully");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }

  Future<bool> addProductToCart({required BuildContext context,required String productId,required int quantity}) async{
    try{
      var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/user/cart/add"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "productId": productId,
          "quantity": quantity,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Product added to cart successfully");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }
  Future<bool> removeProductFromCart({required BuildContext context,required String cartId}) async{
    try{
      var response = await http.delete(Uri.parse("${ApiEndpoint.baseUrl}/api/user/cart/remove?cartId=$cartId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Product removed from cart successfully");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }
  Future<bool> addProductToBookmarks({required BuildContext context,required String productId}) async{
    try{
      var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/user/save/product"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "productId": productId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Product added to bookmarks successfully");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }
  Future<bool> removeProductFromBookmarks({required BuildContext context,required String productId}) async{
    return false;
    try{
      var response = await http.delete(Uri.parse("${ApiEndpoint.baseUrl}/api/user/cart/remove?cartId=$productId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Product removed from bookmarks successfully");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }
  Future<bool> updateProductInCart({required BuildContext context,required String cartId,required int quantity}) async{
    try{
      var response = await http.put(Uri.parse("${ApiEndpoint.baseUrl}/api/user/cart/update"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "cartId": cartId,
          "quantity": quantity,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Product updated in cart successfully");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }
  Future<bool> confirmProductCheckout({required BuildContext context,required String address,required String reference}) async{
    try{
      var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/user/checkout"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "refId": reference,
          "shippingAddress": address,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Checkout successful");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }
  Future<bool> confirmProductCheckoutInDollar({required BuildContext context,required String address,required String reference}) async{
    try{
      var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/checkout/dollar"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "refId": reference,
          "shippingAddress": address,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Checkout successful");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }
  Future<bool> updateShippingAddress({required BuildContext context,required LocationModel location})async{
    try{
      var response = await http.put(Uri.parse("${ApiEndpoint.baseUrl}/api/user/profile/update"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "location": {
            "address": location.address,
            "city": location.city,
            "state": location.state,
            "country": location.country,
          },
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setUserData(userData?.copyWith(location: location));
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Shipping address updated successfully");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }
  Future<CartListModel> fetchCart({required BuildContext context,bool showLoader = true}) async {
   if(showLoader){
     AppUiOverlay.showLoadingIndicator(context);
   }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/user/cart"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        CartListModel responseData = CartListModel.fromJson(data);
        AppUiOverlay.dismissLoadingIndicator();
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
        AppUiOverlay.dismissLoadingIndicator();
        return CartListModel(data: []);
      }
    } else {
      AppUiOverlay.dismissLoadingIndicator();
      return CartListModel(data: []);
    }
  }
  Future<int> getItemCountInCart({required BuildContext context})async{
    var items = await fetchCart(context: context,showLoader: false);
    var count = 0;
    if(items.data != null){
      items.data?.forEach((e){
        count += e.quantity?.toInt() ?? 0;
      });
    }
    return count;
  }

  Future<OrderListData> fetchOrders({required BuildContext context,bool showLoader = false}) async {
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/user/orders"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        OrderListData responseData = OrderListData.fromJson(data);
       if(showLoader){
         AppUiOverlay.dismissLoadingIndicator();
       }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return OrderListData(data: []);
      }
    } else {
      if(showLoader){
        AppUiOverlay.dismissLoadingIndicator();
      }
      return OrderListData(data: []);
    }
  }
  Future<OrderDetails> fetchOrderDetails({required BuildContext context,required String orderId,bool showLoader = false}) async {
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/user/order/items?orderId=$orderId"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        OrderDetails responseData = OrderDetails.fromJson(data);
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return OrderDetails(data: []);
      }
    } else {
      if(showLoader){
        AppUiOverlay.dismissLoadingIndicator();
      }
      return OrderDetails(data: []);
    }
  }
  Future<CustomerOrderDetails> fetchCustomersOrders({required BuildContext context,bool showLoader = false}) async {
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/vendor/order/items"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        CustomerOrderDetails responseData = CustomerOrderDetails.fromJson(data);
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return CustomerOrderDetails(data: []);
      }
    } else {
      if(showLoader){
        AppUiOverlay.dismissLoadingIndicator();
      }
      return CustomerOrderDetails(data: []);
    }
  }
  Future<bool> updateOrderStatus({required BuildContext context,required String status, required String orderId})async{
    try{
      var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/user/order/item/update/status"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "orderItemId" : orderId,
          "status": status.toLowerCase(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Order updated successfully");
        return true;
      }else{
        var message = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: message?.toString() ?? "An error occurred, please try again later");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred, please try again later");
    }
    return false;
  }

  AdvertModel? _advertModel;
  AdvertModel? get advertModel => _advertModel;
  Future<AdvertModel?> fetchAdverts({required BuildContext context,bool force = false,bool showLoader = false}) async {
    if (_advertModel != null && !force) {
      return _advertModel;
    }
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/adverts"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        AdvertModel responseData = AdvertModel.fromJson(data);
        _advertModel = responseData;
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
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

  CategoriesModel? _advertCategoriesModel;
  CategoriesModel? get advertCategoriesModel => _advertCategoriesModel;
  Future<CategoriesModel?> fetchAdvertCategories({required BuildContext context,bool force = false,bool showLoader = false}) async {
    if (_advertCategoriesModel != null && !force) {
      return _advertCategoriesModel;
    }
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/vendor/categories"),
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
        _advertCategoriesModel = responseData;
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
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

  AdvertModel? _userAdvertModel;
  AdvertModel? get userAdvertModel => _userAdvertModel;
  Future<AdvertModel?> fetchUserAdverts({required BuildContext context,bool force = false,bool showLoader = false}) async {
    if (_userAdvertModel != null && !force) {
      return _userAdvertModel;
    }
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/vendor/adverts"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        AdvertModel responseData = AdvertModel.fromJson(data);
        _userAdvertModel = responseData;
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
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
  Future<bool> createAdvert({
    required BuildContext context,
    required String categoryId,
    required String title,
    required String description,
    required String link,
    required bool showOnHomepage,
    required String mediaUrl,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/vendor/adverts"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${StorageService().getString('token')}'
        },
        body: json.encode(
          {
            "categoryId": categoryId,
            "title": title,
            "description": description,
            "link": link,
            "showOnHomepage": showOnHomepage,
            "media_url": mediaUrl,
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
  Future<bool> updateAdvert({
    required BuildContext context,
    required String categoryId,
    required String title,
    required String description,
    required String link,
    required bool showOnHomepage,
    required String mediaUrl,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http.put(Uri.parse("${ApiEndpoint.baseUrl}/api/vendor/adverts"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${StorageService().getString('token')}'
        },
        body: json.encode(
          {
            "categoryId": categoryId,
            "title": title,
            "description": description,
            "link": link,
            "showOnHomepage": showOnHomepage,
            "media_url": mediaUrl,
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

  Future<bool> createReview({
    required BuildContext context,
    required String productId,
    required String orderId,
    required String comment,
    required num rating,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      notifyListeners();

      var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/user/add/review"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${StorageService().getString('token')}'
        },
        body: json.encode(
          {
            "productId": productId,
            "orderId": orderId,
            "comment": comment,
            "rating": rating,
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
  Future<ReviewModels?> fetchUserReviews({required BuildContext context,required String productId,bool showLoader = false}) async {
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/user/get/review?productId=$productId"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        ReviewModels responseData = ReviewModels.fromJson(data);
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
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

  Future<UserModel?> fetchProfile({required BuildContext context,bool showLoader = false,bool force = false}) async {
    if(force && _userDataService.userData != null){
      return UserModel(
        data: _userDataService.userData,
      );
    }
    if(showLoader){
      AppUiOverlay.showLoadingIndicator(context);
    }
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/user/profile"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        UserModel responseData = UserModel.fromJson(data);
        _userDataService.setUserData = responseData.data;
        if(showLoader){
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
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

  Future<paystackData.PaymentData?> initiatePayment({
    required BuildContext context,
    required double amount,
    Function(paystackData.PaymentData data)? onPaymentCompleted,
    Function(String reason)? onPaymentFailed,
  }) async {
    var completer = Completer<paystackData.PaymentData?>();
    try {
      final uniqueTransRef = paystack.PayWithPayStack().generateUuidV4();
      paystack.PayWithPayStack().now(
        context: context,
        secretKey: _paymentGatewayKeyService.paymentKey!.secretKey!,
        customerEmail: email ?? "",
        reference: uniqueTransRef,
        currency: "NGN",
        amount: amount,
        callbackUrl: "https://google.com",
        transactionCompleted: (paymentData) {
          debugPrint("==> Transaction completed $paymentData");
          if (onPaymentCompleted != null) {
            onPaymentCompleted(paymentData);
          }
          completer.complete(paymentData);
        },
        transactionNotCompleted: (reason) {
          debugPrint("==> Transaction failed reason $reason");
          if (onPaymentFailed != null) {
            onPaymentFailed(reason);
          }
          completer.complete(null);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      completer.complete(null);
    }
    return completer.future;
  }
  List<ListenableServiceMixin> get listenableServices => [_userDataService];
}
