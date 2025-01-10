import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kudu/app/locator.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/services/profile_service.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:kudu/core/strings.dart';
import 'package:kudu/data/api/endpoints.dart';
import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/models/user.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:kudu/services/store_service.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class HomeViewModel extends ChangeNotifier {
  final UserDataService _userDataService = locator<UserDataService>();
  final StoreService _storeService = locator<StoreService>();

  List<GetStoreModel> _getStoreModel = [];
  List<GetStoreModel> get getStoreModel => _getStoreModel;

  String? get firstName => _userDataService.userData?.firstName;
  String? get lastName => _userDataService.userData?.lastName;
  String? get email => _userDataService.userData?.email;
  String? get phoneNumber => _userDataService.userData?.phoneNumber;
  String? get photo => _userDataService.userData?.photo;
  bool? get isVerified => _userDataService.userData?.isVerified;
  // String? get photo => _userDataService.userData?.photo;

  // RefreshController refreshController =
  //     RefreshController(initialRefresh: false);

  void setup(BuildContext context) async {
    var decodedData =
        jsonDecode('${StorageService().getString('userDetails')}');

    _userDataService.setUserData =
        UserData.fromJson(decodedData as Map<String, dynamic>);
    // UserData.fromJson(decodedData as Map<String, dynamic>);
    refresh(context);
  }

  Future<void> refresh(BuildContext context) async {
    await getStores(context: context, isLoading: false);
    // await _storeViewModel.getStores(context);
    // await fetchWallets(context);
    // await fetchTransactions(context);
    // refreshController.refreshCompleted();
  }

  Future<void> getStores(
      {required BuildContext context, required bool isLoading}) async {
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

      AppUiOverlay()
          .showErrorSnackbarMessage(context, message: 'Internet Error');
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      notifyListeners();

      AppUiOverlay().showErrorSnackbarMessage(context, message: e.toString());

      dPrint("Error received on fetching profile: ${e.toString()}");
    }
  }

  // Future<void> fetchUserProfile({required BuildContext context}) async {
  //   try {
  //     var response = await http.get(
  //         Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.userProfile),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-Type": "application/json",
  //           'Authorization': 'Bearer ${StorageService().getString('token')}'
  //         }).timeout(const Duration(seconds: 60));

  //     print(StorageService().getString('token'));
  //     dPrint('statusCode::: ${response.statusCode}');
  //     dPrint('response::: ${response.body}');

  //     //success
  //     if (response.statusCode == 200) {
  //       dPrint('profile fetched:::');
  //       UserModel? user = UserModel.fromJson(
  //           jsonDecode(response.body) as Map<String, dynamic>);
  //       String fullname = "${user.data?.firstName} ${user.data?.lastName}";

  //       _userDataService.setUserData = user.data;

  //       StorageService().addString('name', fullname);
  //       StorageService().addString('userDetails', jsonEncode(user.data));
  //       StorageService().addBool('isLoggedIn', true);
  //       StorageService().addBool('skipOnBoarding', true);
  //     }
  //     //failure
  //     else {
  //       AppUiOverlay.dismissLoadingIndicator();
  //       notifyListeners();
  //     }
  //   } on SocketException {
  //     AppUiOverlay.dismissLoadingIndicator();
  //     notifyListeners();

  //     AppUiOverlay().showErrorDialog(
  //       context,
  //       "fetch-profile",
  //       info: AppStrings.internetError,
  //       title: 'Internet Error',
  //     );
  //   } catch (e) {
  //     AppUiOverlay.dismissLoadingIndicator();
  //     notifyListeners();

  //     AppUiOverlay().showErrorDialog(
  //       context,
  //       "fetch-profile",
  //       info: AppStrings.unknownError,
  //       title: 'Unknown Error',
  //     );

  //     dPrint("Error received on fetching profile: ${e.toString()}");
  //   }
  // }

  Future<void> fetchCurrency(BuildContext context) async {
    try {
      var response = await http
          .get(Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.currency), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      }).timeout(const Duration(seconds: 60));

      print(StorageService().getString('token'));
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

  // Future<void> refreshHome(BuildContext context) async {
  //   await fetchUserProfile(context: context);
  // }

  @override
  List<ListenableServiceMixin> get listenableServices => [_userDataService];
}
