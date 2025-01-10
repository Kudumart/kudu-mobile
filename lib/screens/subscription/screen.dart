import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/models/subscription.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/utils/price_formatter.dart';

import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';

part 'widgets/subscription_plan_card.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppUiColor.grey50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("Subscriptions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 35,
                UiConstant.horizontalPadding, 10),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Get the Best Deals on Our Subscription Plans",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                const Text(
                  "Subscribe to our plans as a Vendor and enjoy all opportunities that comes with it",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 33),
                ..._plans.map((plan) => _SubscriptionPlanCard(plan))
              ],
            ))));
  }

  static final List<Subscription> _plans = [
    const Subscription(
        name: "Basic",
        price: 0,
        currency: "\$",
        isActive: true,
        benefits: [
          "View products",
          "View auctions",
          "Contact vendors and purchase",
          "Post paid adverts",
        ]),
    const Subscription(
        name: "Standard",
        price: 25,
        currency: "\$",
        isActive: false,
        benefits: [
          "Everything included in basic",
          "View multiple online auctions",
          "Bid up to \$2000 USD",
          "Bid up to 5 products at a time",
        ]),
    const Subscription(
        name: "Premium",
        price: 50,
        currency: "\$",
        isActive: false,
        benefits: [
          "Everything included in Standard",
          "Bid up to 5 products at a time",
          "Bid up to \$100k USD",
          "Receive priority customer support",
        ]),
  ];
}
