import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/models/order_summary.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/core/shared_widgets/button_as_bottom_nav_bar.dart';
import 'package:kudu/core/shared_widgets/divider.dart';
import 'package:kudu/core/utils/price_formatter.dart';

import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';

part 'widgets/order_summary.dart';
part 'widgets/delivery_address.dart';
part 'widgets/payment_method.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderSummary _order = OrderSummary(
      currency: "\$", subTotal: 1247, vat: 0.00, shippingPrice: 4800);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Checkout",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            centerTitle: false,
            titleSpacing: 0,
            leading: const AppBackButton(),
          ),
          bottomNavigationBar:
              ElevatedButtonAsButtonNavBar(text: "Checkout", onPressed: () {}),
          body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 24,
                UiConstant.horizontalPadding, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _OrderSummaryHeader(),
                  const SizedBox(height: 13),
                  _OrderSummary(_order),
                  const SizedBox(height: 24),
                  const _DeliveryAddressHeader(),
                  const SizedBox(height: 10),
                  const _DeliveryAddressField(),
                  const SizedBox(height: 25),
                  const Text("Choose Payment Method",
                      style: TextStyle(
                          color: Color(0xFF9e9e9e),
                          fontWeight: FontWeight.w400,
                          fontSize: 13)),
                  const SizedBox(height: 12),
                  const _PaymentMethodSelector()
                ],
              ),
            ),
          )),
    );
  }
}
