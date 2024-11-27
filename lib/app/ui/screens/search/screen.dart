import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/ui/sample_data.dart';
import 'package:kudu/app/ui/shared_widgets/product_card_view_1/product_card_view_1.dart';

import '../../../models/product.dart';
import '../../colors.dart';
import '../../constants.dart';
import '../../images.dart';
import '../../shared_widgets/back_button.dart';

part 'widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Product> _products = [
    ...sampleSimilarProducts,
    ...sampleSimilarProducts,
    ...sampleSimilarProducts,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Mobile Phones",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            centerTitle: false,
            bottom: const _SearchBarWithFilter(),
            titleSpacing: 0,
            leading: const AppBackButton(),
          ),
          body: SafeArea(
              minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding,
                  24, UiConstant.horizontalPadding, 10),
              child: SingleChildScrollView(
                child: Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 19,
                  spacing: 5,
                  children: _products
                      .map((product) => ProductCardView1(product))
                      .toList(),
                ),
              )),
        ));
  }
}
