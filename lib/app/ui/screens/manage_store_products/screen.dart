import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/constants.dart';
import 'package:kudu/app/ui/images.dart';

import 'package:kudu/app/ui/sample_data.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';

import '../../../models/enums.dart';
import '../../../models/product.dart';
import '../../../models/store.dart';
import '../../routes/routes.dart';

part 'widgets/product_card.dart';
part 'widgets/checkout_calculator.dart';
part 'widgets/quantity_mutator.dart';
part 'widgets/edit_button.dart';

class StoreProductsScreen extends StatefulWidget {
  final Store store;
  const StoreProductsScreen(this.store, {super.key});

  @override
  State<StoreProductsScreen> createState() => _StoreProductsScreenState();
}

class _StoreProductsScreenState extends State<StoreProductsScreen> {
  final List<Product> products = [
    ...sampleProducts,
    ...sampleProducts,
    ...sampleProducts
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => const AddProductScreenRoute().push(context),
          backgroundColor: AppUiColor.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: const Text(
            "My Products",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          centerTitle: false,
          leading: const AppBackButton(),
          titleSpacing: 0,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 24,
                UiConstant.horizontalPadding, 10),
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) =>
                  _CartProductCard(products[index]),
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemCount: products.length,
            )));
  }
}
