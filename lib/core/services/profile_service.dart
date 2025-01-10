import 'package:kudu/models/user.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';

class UserDataService with ListenableServiceMixin {
  final RxValue<UserData?> _userData = RxValue<UserData?>(null);

  ProfileService() {
    listenToReactiveValues([_userData]);
  }

  UserData? get userData => _userData.value;

  set setUserData(UserData? val) {
    _userData.value = val;
    notifyListeners();
  }

  

  void clearUserData() {
    _userData.value = null;
  }
}
