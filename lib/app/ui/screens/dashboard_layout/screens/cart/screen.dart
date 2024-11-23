import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/constants.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/sample_data.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';

import '../../../../../models/enums.dart';
import '../../../../../models/product.dart';

part 'widgets/product_card.dart';
part 'widgets/checkout_calculator.dart';
part 'widgets/quantity_mutator.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Shopping Cart",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          centerTitle: false,
          leading: const AppBackButton(),
          titleSpacing: 0,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_outlined,
                    color: Colors.black, size: 20))
          ],
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 24,
                UiConstant.horizontalPadding, 10),
            child: Column(
              children: [
                const Expanded(child: _CartProducts(sampleProducts)),
                const SizedBox(height: 30),
                const _CheckoutCalculator(),
                const SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () => const CheckoutScreenRoute().push(context),
                    child: const Text("Checkout"))
              ],
            )));
  }
}

class _CartProducts extends StatelessWidget {
  final List<Product> products;
  const _CartProducts(this.products);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) => _CartProductCard(products[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemCount: products.length,
    );
  }
}
