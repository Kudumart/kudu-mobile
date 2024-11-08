import 'package:flutter/material.dart';
import 'package:kudu/app/ui/shared_widgets/radial_background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RadialGradientBackground(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.red,
      ),
    );
  }
}
