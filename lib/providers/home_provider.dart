import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:kudu/services/country_service.dart';
import 'package:kudu/services/payment_key_service.dart';
import 'package:kudu/services/store_service.dart';
import 'package:kudu/models/user.dart';
import 'package:kudu/providers/auth_viewmodel.dart';
import 'package:provider/provider.dart';
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
import '../models/services/service_models.dart';

class HomeViewModel extends ChangeNotifier {
  final UserDataService _userDataService = locator<UserDataService>();
  final PaymentGatewayKeyService _paymentGatewayKeyService = locator<PaymentGatewayKeyService>();
  final CountryService _countryService = locator<CountryService>();

  final StoreService _storeService = locator<StoreService>();

  CountryService get countryService => _countryService;
  String get selectedCountryName => _countryService.selectedCountryValue;
  String get currencySymbol => _countryService.currencySymbol;

  String appendCountryParam(String url) {
    final c = _countryService.selectedCountryValue;
    if (c.isEmpty) return url;
    final sep = url.contains('?') ? '&' : '?';
    return '$url${sep}country=${Uri.encodeQueryComponent(c)}';
  }

  String? _lastFetchedCountry;

  void clearProductCache() {
    _productsListModel = null;
    _popularProductsListModel = null;
    _productsWithCategoryId.clear();
    _productsWithCondition.clear();
    _productsWithSubCategory.clear();
    _productsWithVendor.clear();
    _auctionProductsListModel = null;
    notifyListeners();
  }

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
  ProductsListModel? _popularProductsListModel;

  Future<ProductsListModel?> fetchAllProducts({
    required BuildContext context,
    bool showLoader = false,
    bool force = false,
    String? search,
    bool isPopular = false,
  }) async {
    final currentCountry = _countryService.selectedCountryValue;
    if (_lastFetchedCountry != currentCountry) {
      _lastFetchedCountry = currentCountry;
      _productsListModel = null;
      _popularProductsListModel = null;
      _productsWithCategoryId.clear();
      _productsWithCondition.clear();
      _productsWithSubCategory.clear();
      _productsWithVendor.clear();
      _auctionProductsListModel = null;
    }

    if ((search ?? "").trim().isEmpty && !force) {
      if (isPopular && _popularProductsListModel != null) {
        return _popularProductsListModel;
      } else if (!isPopular && _productsListModel != null) {
        return _productsListModel;
      }
    }

    if (showLoader) {
      AppUiOverlay.showLoadingIndicator(context);
    }
    var url = "${ApiEndpoint.baseUrl}/api/products";
    if ((search ?? "").trim().isNotEmpty) {
      url = "${ApiEndpoint.baseUrl}/api/products/autocomplete?q=${Uri.encodeQueryComponent(search!.trim())}";
      if (isPopular) {
        url += "&popular=true";
      }
    } else {
      if (isPopular) {
        url += "?popular=true";
      }
    }
    url = appendCountryParam(url);

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = json.decode(response.body);
        ProductsListModel responseData = ProductsListModel.fromJson(data);
        if ((search ?? "").trim().isNotEmpty && responseData.data != null) {
          responseData.data = sortProductsByRelevance(responseData.data!, search!);
        } else if ((search ?? "").trim().isEmpty) {
          if (isPopular) {
            _popularProductsListModel = responseData;
          } else {
            _productsListModel = responseData;
          }
        }
        if (showLoader) {
          AppUiOverlay.dismissLoadingIndicator();
        }
        return responseData;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    if (showLoader) {
      AppUiOverlay.dismissLoadingIndicator();
    }
    return null;
  }

  int _calculateProductRelevance(ProductData p, String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    final name = (p.name ?? '').trim().toLowerCase();
    if (name.isEmpty || query.isEmpty) return 100;

    final words = name.split(RegExp(r'\s+'));

    // Priority 0: Title starts with exact query term (e.g., "Car android venza", "Car Tyres")
    if (name.startsWith(query)) return 0;

    // Priority 1: Title contains a word starting with exact query (e.g., "Solite car Battery", "2015 car")
    if (words.any((w) => w.startsWith(query))) return 10;

    // Priority 2: Title contains exact word boundary
    if (name.contains(RegExp('\\b${RegExp.escape(query)}\\b'))) return 20;

    // Priority 3: Subcategory / Category contains query term
    final subCat = (p.subCategory?.name ?? '').toLowerCase();
    if (subCat.contains(query)) return 30;

    // Priority 4: Partial substring match embedded inside another word (e.g., "scarf", "carpet") -> Placed at the bottom
    if (name.contains(query)) return 60;

    return 100;
  }

  List<ProductData> sortProductsByRelevance(List<ProductData> products, String query) {
    if (query.trim().isEmpty || products.isEmpty) return products;
    final sortedList = List<ProductData>.from(products);
    sortedList.sort((a, b) {
      final scoreA = _calculateProductRelevance(a, query);
      final scoreB = _calculateProductRelevance(b, query);
      if (scoreA != scoreB) {
        return scoreA.compareTo(scoreB);
      }
      return (a.name ?? '').compareTo(b.name ?? '');
    });
    return sortedList;
  }

  /// Live search suggestions for the search bar dropdown — mirrors the web
  /// app's `/api/products/autocomplete` usage (name/SKU/keywords match,
  /// ranked by relevance, capped at 10 results server-side).
  Future<List<ProductData>> fetchAutocompleteSuggestions(String query) async {
    if(query.trim().isEmpty){
      return [];
    }
    try{
      var url = appendCountryParam("${ApiEndpoint.baseUrl}/api/products/autocomplete?q=${Uri.encodeQueryComponent(query.trim())}");
      var response = await http.get(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final list = (data['data'] as List? ?? []).map((v) => ProductData.fromJson(v)).toList();
        return sortProductsByRelevance(list, query);
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    return [];
  }

  final Map<String,ProductsListModel> _productsWithCategoryId = {};
  Future<ProductsListModel?> fetchProductsByCategory({required BuildContext context,required String categoryId,bool force = false,String? search,bool isPopular = false}) async {
    if(_productsWithCategoryId[categoryId] != null && !force){
      return _productsWithCategoryId[categoryId];
    }
    AppUiOverlay.showLoadingIndicator(context);

    var url = "${ApiEndpoint.baseUrl}/api/products?categoryId=$categoryId";
    if((search ?? "").trim().isNotEmpty){
      url += "&search=${search ?? ""}";
      if(isPopular){
        url += "&popular=true";
      }
    }else{
      if(isPopular){
        url += "&popular=true";
      }
    }
    url = appendCountryParam(url);
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
      url += "&search=${search ?? ""}";
      if(isPopular){
        url += "&popular=true";
      }
    }else{
      if(isPopular){
        url += "&popular=true";
      }
    }
    url = appendCountryParam(url);
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
      url += "&search=${search ?? ""}";
      if(isPopular){
        url += "&popular=true";
      }
    }else{
      if(isPopular){
        url += "&popular=true";
      }
    }
    url = appendCountryParam(url);
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

  final Map<String, ProductsListModel> _productsWithVendor = {};
  Future<List<ProductData>> fetchProductsByVendor({required BuildContext context, required String vendorId}) async {
    try {
      var url = appendCountryParam("${ApiEndpoint.baseUrl}/api/products?vendorId=$vendorId&limit=12");
      var response = await http.get(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List).map<ProductData>((v) => ProductData.fromJson(v)).toList();
        }
      }
    } catch (_) {}
    return [];
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

    try {
      var url1 = "${ApiEndpoint.baseUrl}/api/auction/products".addParamsToUrl({
        "name": name,
        "storeId": storeId,
        "subCategoryName": subCategoryName,
        "condition": condition,
        "limit": limit,
        "offset": offset,
        "startDate": startDate,
        "auctionStatus": auctionStatus,
      });
      url1 = appendCountryParam(url1);

      var url2 = "${ApiEndpoint.baseUrl}/api/products?auctionStatus=ongoing";
      url2 = appendCountryParam(url2);

      final req1 = http.get(Uri.parse(url1), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      });

      final req2 = http.get(Uri.parse(url2), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      });

      final results = await Future.wait([req1, req2]);

      final Map<String, ProductData> uniqueMap = {};

      for (var response in results) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          try {
            final data = json.decode(response.body);
            ProductsListModel modelData = ProductsListModel.fromJson(data);
            if (modelData.data != null) {
              for (var prod in modelData.data!) {
                if (prod.id != null && prod.id!.isNotEmpty) {
                  uniqueMap[prod.id!] = prod;
                }
              }
            }
          } catch (e) {
            if (kDebugMode) print(e);
          }
        }
      }

      ProductsListModel combinedModel = ProductsListModel(
        data: uniqueMap.values.toList(),
      );

      if (save) {
        _auctionProductsListModel = combinedModel;
      }
      if (showLoader) {
        AppUiOverlay.dismissLoadingIndicator();
      }
      return combinedModel;
    } catch (e) {
      if (kDebugMode) print(e);
    }

    if (showLoader) {
      AppUiOverlay.dismissLoadingIndicator();
    }
    return null;
  }

  Future<ProductData?> fetchSingleAuctionProduct(String auctionProductId) async {
    try {
      final url = appendCountryParam("${ApiEndpoint.baseUrl}/api/auction/product?auctionproductId=$auctionProductId");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          if (token.isNotEmpty) "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["data"] != null) {
          return ProductData.fromJson(decoded["data"]);
        }
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching single auction product: $e");
    }
    return null;
  }

  Future<bool> placeBid({
    required BuildContext context,
    required String auctionProductId,
    required double bidAmount,
  }) async {
    if (_userDataService.userData == null) {
      AppUiOverlay().showErrorSnackbarMessage(context, message: "Please log in to place a bid.");
      const SignInScreenRoute().push(context);
      return false;
    }

    AppUiOverlay.showLoadingIndicator(context);

    try {
      final response = await http.post(
        Uri.parse("${ApiEndpoint.baseUrl}/api/user/place/bid"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "auctionProductId": auctionProductId,
          "bidAmount": bidAmount,
        }),
      );

      AppUiOverlay.dismissLoadingIndicator();

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Bid placed successfully!");
        return true;
      } else {
        final decoded = jsonDecode(response.body);
        final message = decoded["message"] ?? "Failed to place bid";
        AppUiOverlay().showErrorSnackbarMessage(context, message: message.toString());
        return false;
      }
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorSnackbarMessage(context, message: "Failed to place bid. Please try again.");
      return false;
    }
  }

  Future<bool> showInterest({
    required BuildContext context,
    required String auctionProductId,
    required double amountPaid,
    double? retryBidAmount,
  }) async {
    if (_userDataService.userData == null) {
      AppUiOverlay().showErrorSnackbarMessage(context, message: "Please log in to participate in auction.");
      const SignInScreenRoute().push(context);
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse("${ApiEndpoint.baseUrl}/api/user/auction/interest"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "auctionProductId": auctionProductId,
          "amountPaid": amountPaid,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (retryBidAmount != null) {
          return await placeBid(
            context: context,
            auctionProductId: auctionProductId,
            bidAmount: retryBidAmount,
          );
        }
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Interest registered successfully!");
        return true;
      } else {
        final decoded = jsonDecode(response.body);
        AppUiOverlay().showErrorSnackbarMessage(context, message: decoded["message"]?.toString() ?? "Failed to register interest");
        return false;
      }
    } catch (e) {
      AppUiOverlay().showErrorSnackbarMessage(context, message: "Failed to register interest");
      return false;
    }
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
    var url = appendCountryParam("${ApiEndpoint.baseUrl}/api/product?productId=$productId");
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

  Future<List<ServiceCategory>> fetchServiceCategories() async {
    try {
      var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.serviceCategories}"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return (data['data'] as List? ?? []).map((v) => ServiceCategory.fromJson(v)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return [];
  }

  Future<List<ServiceCategory>> fetchServiceSubCategories(String categoryId) async {
    try {
      var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.serviceSubCategories}/$categoryId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return (data['data'] as List? ?? []).map((v) => ServiceCategory.fromJson(v)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return [];
  }

  Future<ServicesListModel?> fetchServices({
    String? categoryId,
    String? subCategoryId,
    String? search,
    int page = 1,
  }) async {
    try {
      var queryParams = <String, String>{
        "page": page.toString(),
        "limit": "10",
        if (categoryId != null) "categoryId": categoryId,
        if (subCategoryId != null) "subCategoryId": subCategoryId,
        if ((search ?? "").trim().isNotEmpty) "search": search!.trim(),
      };
      var uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.services}").replace(queryParameters: queryParams);
      var response = await http.get(uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ServicesListModel.fromJson(data);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<ServiceData?> fetchServiceById(String serviceId) async {
    try {
      var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.service}/$serviceId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ServiceData.fromJson(data['data']);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
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

  Future<List<String>?> uploadImages({required List<String> images, MediaType? fileType}) async {
    if (images.isEmpty) {
      return [];
    }
    try {
      List<String> listToReturn = [];

      await Future.forEach(images, (image) async {
        if (image.startsWith('http://') || image.startsWith('https://')) {
          listToReturn.add(image);
          return;
        }

        var url = Uri.parse("${ApiEndpoint.baseUrl}/api/upload/file");
        var request = http.MultipartRequest("POST", url);
        request.headers.addAll({
          "Accept": "application/json",
          if (token.isNotEmpty) 'Authorization': token,
        });

        if (kIsWeb || image.startsWith('blob:')) {
          final xFile = XFile(image);
          final bytes = await xFile.readAsBytes();
          final multiPartFile = http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
            contentType: fileType ?? MediaType('image', 'jpeg'),
          );
          request.files.add(multiPartFile);
        } else {
          try {
            final multiPartFile = await http.MultipartFile.fromPath(
              'image',
              image,
              contentType: fileType ?? MediaType('image', 'jpeg'),
            );
            request.files.add(multiPartFile);
          } catch (_) {
            final xFile = XFile(image);
            final bytes = await xFile.readAsBytes();
            final multiPartFile = http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
              contentType: fileType ?? MediaType('image', 'jpeg'),
            );
            request.files.add(multiPartFile);
          }
        }

        var response = await request.send();
        if (response.statusCode == 200 || response.statusCode == 201) {
          final respStr = await response.stream.bytesToString();
          final decoded = jsonDecode(respStr);
          if (decoded is Map<String, dynamic>) {
            final imgUrl = decoded["data"]?.toString() ?? "";
            if (imgUrl.isNotEmpty) {
              listToReturn.add(imgUrl);
            }
          }
        }
      });
      return listToReturn;
    } catch (e) {
      if (kDebugMode) {
        print("uploadImages error: $e");
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
    try{
      var response = await http.delete(Uri.parse("${ApiEndpoint.baseUrl}/api/user/remove/save/product/$productId"),
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

  Future<bool> submitProductOffer({
    required BuildContext context,
    required String productId,
    required double offeredPrice,
    String? message,
  }) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      var response = await http.post(
        Uri.parse("${ApiEndpoint.baseUrl}/api/user/products/$productId/offers"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode({
          "offeredPrice": offeredPrice,
          if (message != null && message.trim().isNotEmpty) "message": message.trim(),
        }),
      );
      AppUiOverlay.dismissLoadingIndicator();

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Offer submitted successfully!");
        return true;
      } else {
        var msg = jsonDecode(response.body)["message"];
        AppUiOverlay().showErrorSnackbarMessage(context, message: msg?.toString() ?? "Could not submit offer, please try again.");
      }
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      AppUiOverlay().showErrorSnackbarMessage(context, message: "An error occurred while submitting offer.");
    }
    return false;
  }

  Future<List<dynamic>> fetchMyOffers({required BuildContext context}) async {
    try {
      var response = await http.get(
        Uri.parse("${ApiEndpoint.baseUrl}/api/user/offers?limit=50"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': token,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return (data['data'] as List? ?? []);
      }
    } catch (_) {}
    return [];
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
