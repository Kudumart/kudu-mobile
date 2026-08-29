import 'package:flutter/material.dart';
import 'package:kudu/providers/auth_viewmodel.dart';
import 'package:kudu/providers/chat_view_model.dart';
import 'package:kudu/providers/home_provider.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:kudu/app/locator.dart';
import 'package:kudu/data/storage/shared_preferences.dart';
import 'package:kudu/app/routes/routes.dart';
import 'core/theme.dart';

import 'package:kudu/services/country_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await AppStorage.init();
  runApp(
    const Kudu(),
  );
}

class Kudu extends StatelessWidget {
  const Kudu({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: locator<CountryService>(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => StoreViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatViewModel(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: routerConfig,
        debugShowCheckedModeBanner: false,
        theme: UiTheme.light,
      ),
    );
  }
}
