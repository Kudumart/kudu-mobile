import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/models/get_subscription_model.dart';
import 'package:kudu/models/subscription.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/utils/price_formatter.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';

part 'widgets/subscription_plan_card.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProfileViewModel>(context, listen: false)
          .getSubscription(context: context);
    });
  }

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
      body: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          final subscriptions = model.getSubscriptionModel;
          return SafeArea(
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
                  if (subscriptions.isNotEmpty)
                    ...subscriptions.map((subscription) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SubscriptionPlanCard(subscription: subscription),
                      );
                    })
                  else
                    const Center(
                      child: Text("No subscription plans available"),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
