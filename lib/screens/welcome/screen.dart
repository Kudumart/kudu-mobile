import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kudu/app/locator.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/providers/auth_viewmodel.dart';

part 'widgets/background.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    bool isLoggedIn = StorageService().getBool('isLoggedIn') ?? false;

    AuthViewmodel _auth = locator<AuthViewmodel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1);
      Timer(const Duration(milliseconds: 900), () {
        isLoggedIn
            ? _auth.fetchUserProfile(context: context)
            : const WelcomeScreen2Route().push(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _RingBackground(
      child: Hero(
          tag: "kudu_logo",
          child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _opacity,
              child: Image.asset(AppUiImage.kuduLogo))),
    );
  }
}

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return _RingBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 70, 18, 20),
        child: Column(
          children: [
            Hero(tag: "kudu_logo", child: Image.asset(AppUiImage.kuduLogo)),
            Expanded(
                child: Center(
                    child: Image.asset(
              AppUiImage.animatedCart,
              height: 274,
              width: 247,
              fit: BoxFit.contain,
            ))),
            const Text("Discover. Thrive. Shop.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 35, height: 1.2)),
            const Text("On Kudu",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  height: 1.2,
                  color: Color.fromARGB(255, 246, 167, 125),
                )),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () => const OnboardingScreenRoute().push(context),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
