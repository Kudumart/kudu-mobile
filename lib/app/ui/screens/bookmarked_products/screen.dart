import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/app/models/bookmarked_product.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/sample_data.dart';
import 'package:kudu/app/ui/utils/price_formatter.dart';

import '../../constants.dart';
import '../../shared_widgets/back_button.dart';

part 'widgets/bookmarked_product_card.dart';

class BookmarkedProductsScreen extends StatefulWidget {
  const BookmarkedProductsScreen({super.key});

  @override
  State<BookmarkedProductsScreen> createState() =>
      _BookmarkedProductsScreenState();
}

class _BookmarkedProductsScreenState extends State<BookmarkedProductsScreen> {
  final List<BookmarkedProduct> _bookmarkedProducts = sampleProducts
      .map((product) => BookmarkedProduct(
          on: DateTime.now().subtract(const Duration(days: 5)),
          product: product))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("Bookmarked Items",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 15,
                UiConstant.horizontalPadding, 10),
            child: ListView.separated(
                padding: const EdgeInsets.all(0),
                itemBuilder: (_, index) =>
                    _BookmarkedProductCard(_bookmarkedProducts[index]),
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemCount: _bookmarkedProducts.length)));
  }
}
