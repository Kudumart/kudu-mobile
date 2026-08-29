import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:kudu/core/services/profile_service.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/providers/auth_viewmodel.dart';
import 'package:kudu/providers/home_provider.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:kudu/services/country_service.dart';
import 'package:kudu/services/currency_service.dart';
import 'package:kudu/services/payment_key_service.dart';
import 'package:kudu/services/store_service.dart';
import 'package:kudu/services/subscription_service.dart';

import 'package:path_provider/path_provider.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator({bool test = false}) async {
  /// SERVICES
  ///
  ///
  ///
  ///
  if (!kIsWeb) {
    Directory appDocDir =
        test ? Directory.current : await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
  }

  if (!test) {
    locator.registerLazySingleton<HiveInterface>(() => Hive);
  }

  locator.registerLazySingleton<CountryService>(() => CountryService());
  locator.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
  locator.registerLazySingleton<CurrencyService>(() => CurrencyService());
  locator.registerLazySingleton<PaymentGatewayKeyService>(
      () => PaymentGatewayKeyService());
  locator.registerLazySingleton<StorageService>(() => StorageService());
  locator.registerLazySingleton<UserDataService>(() => UserDataService());
  locator.registerLazySingleton<StoreService>(() => StoreService());
  locator
      .registerLazySingleton<SubscriptionService>(() => SubscriptionService());

  /// PROVIDERS
  ///
  ///
  ///
  ///
  locator.registerLazySingleton<AuthViewmodel>(() => AuthViewmodel());
  locator.registerLazySingleton<StoreViewModel>(() => StoreViewModel());

  await StorageService().init();
}
