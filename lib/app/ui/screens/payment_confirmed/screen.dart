import 'package:flutter/material.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/shared_widgets/button_as_bottom_nav_bar.dart';

import '../../constants.dart';
import '../../images.dart';
import '../../shared_widgets/back_button.dart';

class PaymentConfirmed extends StatelessWidget {
  const PaymentConfirmed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          "Payment Status",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        leading: AppBackButton(
          onPressed: () => const HomeScreenRoute().go(context),
        ),
        titleSpacing: 0,
      ),
      bottomNavigationBar: ElevatedButtonAsButtonNavBar(
          text: "Continue Shopping", onPressed: () {}),
      body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 65,
              UiConstant.horizontalPadding, 10),
          child: Column(
            children: [
              Container(
                  constraints: const BoxConstraints(
                    minWidth: 270,
                    minHeight: 270,
                    maxHeight: 398,
                    maxWidth: 398,
                  ),
                  child: LayoutBuilder(
                      builder: (_, constraints) => Image.asset(
                          AppUiImage.paymentConfirmed,
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          fit: BoxFit.contain))),
              const SizedBox(height: 35),
              const Text(
                "Payment Confirmed",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )
            ],
          )),
    );
  }
}
