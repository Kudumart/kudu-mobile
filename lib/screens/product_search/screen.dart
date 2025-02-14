import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:provider/provider.dart';

import '../../models/enums_and_extensions.dart';
import '../../models/home/products_list_model.dart';
import '../../models/product.dart';
import '../../models/search_filter.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../providers/home_provider.dart';

part 'widgets/search_bar.dart';

class ProductSearchScreen extends StatefulWidget {
  final SearchFilter? searchFilter;
  const ProductSearchScreen({this.searchFilter, super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  ProductsListModel? products;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
    });
  }

  Future<void> getProducts() async {
    if(widget.searchFilter?.isSubCategory ?? false){
      products = await Provider.of<HomeViewModel>(context, listen: false).fetchProductsBySubCategory(context: context, subCategory: widget.searchFilter?.subCategory ?? "",force: true);
    }else if(widget.searchFilter?.isCondition ?? false){
      products = await Provider.of<HomeViewModel>(context, listen: false).fetchProductsByCondition(context: context, condition: widget.searchFilter?.condition ?? "",force: true);
    } else if(widget.searchFilter?.isMainCategory ?? false){
      products = await Provider.of<HomeViewModel>(context, listen: false).fetchProductsByCategory(context: context, categoryId: widget.searchFilter?.categoryId ?? "",force: true);
    }
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.searchFilter?.category ?? "Search for Anything",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            centerTitle: false,
            bottom: const _SearchBarWithFilter(),
            titleSpacing: 0,
            leading: const AppBackButton(),
          ),
          body: SafeArea(
              minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 24, UiConstant.horizontalPadding, 10),
              child: SingleChildScrollView(
                child: Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 19,
                  spacing: 5,
                  children: (products?.data ?? []).map((product) => ProductCardView1(product)).toList(),
                ),
              )),
        ));
  }
}
