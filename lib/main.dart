import 'package:flutter/material.dart';
import 'package:kudu/app/data/api/client.dart';
import 'package:kudu/app/data/storage/shared_preferences.dart';
import 'package:kudu/app/ui/routes/routes.dart';

import 'app/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();
  ApiClient.init();
  runApp(const Kudu());
}

class Kudu extends StatelessWidget {
  const Kudu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerConfig,
      debugShowCheckedModeBanner: false,
      theme: UiTheme.light,
    );
  }
}
