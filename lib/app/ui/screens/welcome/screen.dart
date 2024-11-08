import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/shared_widgets/ring_background.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1);
      Timer(const Duration(milliseconds: 900), () {
        const WelcomeScreen2Route().push(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RingBackground(
      child: Hero(
          tag: "kudu_logo",
          child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _opacity,
              child: Image.asset(AppImage.kuduLogo))),
    );
  }
}

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return RingBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 70, 18, 70),
        child: Column(
          children: [
            Hero(tag: "kudu_logo", child: Image.asset(AppImage.kuduLogo)),
            Expanded(
                child: Center(
                    child: Image.asset(
              AppImage.animatedCart,
              height: 274,
              width: 247,
              fit: BoxFit.contain,
            ))),
            const Text("Discover. Thrive. Shop.",
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 30, height: 1.2)),
            const Text("On Kudu",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  height: 1.2,
                  color: Color.fromARGB(255, 246, 167, 125),
                )),
            const SizedBox(height: 49),
            ElevatedButton(
                onPressed: () => const OnboardingScreenRoute().push(context),
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.black),
                ),
                child: const Text(
                  "Get Started",
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
