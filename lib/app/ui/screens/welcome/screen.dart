import 'package:flutter/material.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/shared_widgets/radial_background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RadialGradientBackground(
      child: Hero(tag: "kudu_logo", child: Image.asset(AppImage.logoFull)),
    );
  }
}

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return RadialGradientBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 70, 18, 70),
        child: Column(
          children: [
            Hero(tag: "kudu_logo", child: Image.asset(AppImage.logoFull)),
            const Expanded(child: SizedBox()),
            Image.asset(AppImage.animatedCart),
            const Expanded(child: SizedBox()),
            const Text("Discover. Thrive. Shop.",
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 35, height: 1.2)),
            Text("On Kudu",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    height: 1.2,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Colors.red, Colors.blue],
                      ).createShader(
                          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)))),
            const SizedBox(height: 49),
            ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(Colors.black),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ))
          ],
        ),
      ),
    );
  }
}
