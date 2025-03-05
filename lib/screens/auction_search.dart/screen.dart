import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/utils/price_formatter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import '../../models/auction.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../models/home/products_list_model.dart';
import '../../providers/chat_view_model.dart';
import '../../providers/home_provider.dart';

part 'widgets/auction_info_card/auction_info_card.dart';
part 'widgets/auction_info_card/widgets/vendor_name.dart';
part 'widgets/auction_info_card/widgets/location.dart';
part 'widgets/auction_info_card/widgets/specs_and_bid_price.dart';

part 'widgets/black_container.dart';
part 'widgets/search_bar.dart';
part 'widgets/filter_button.dart';
part 'widgets/product_conditions.dart';

class AuctionSearchScreen extends StatefulWidget {
  const AuctionSearchScreen({super.key});

  @override
  State<AuctionSearchScreen> createState() => _AuctionSearchScreenState();
}

class _AuctionSearchScreenState extends State<AuctionSearchScreen> {
  final Debouncer _debouncer = Debouncer(milliseconds: 100);
  ProductCondition? selectedCondition;
  ProductsListModel? products;
  ProductsListModel? searchProducts;
  bool loading = false;
  var searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
      searchController.addListener(() {
        _debouncer.run(() {
          if (searchController.text.isEmpty) {
            if(selectedCondition != null) {
              searchProductsByTerm(null);
            }else{
              getProducts(showLoader: false);
            }
          } else {
            searchProductsByTerm(searchController.text);
          }
        });
      });
    });
  }

  Future<void> getProducts({bool showLoader = true}) async {
    if(mounted){
      setState(() {
        loading = true;
      });
    }
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    searchProducts = null;
    products = await provider.fetchAllAuctionProducts(context: context, force: true,showLoader: showLoader);
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> searchProductsByTerm(String? searchTerm) async {
    if(mounted){
      setState(() {
        loading = true;
      });
    }
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    searchProducts = await provider.fetchAllAuctionProducts(context: context, name: searchTerm, condition: selectedCondition?.apiName, force: true,save: false);
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("All Auctions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          forceMaterialTransparency: true,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.only(bottom: 10),
            child: SingleChildScrollView(
              child: Column(children: [
                _BlackContainer(
                  controller: searchController,
                ),
                const SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
                  child: _ProductConditions(
                    active: selectedCondition != null ? ProductCondition.values.indexOf(selectedCondition!) : -1,
                    onSelected: (index) {
                      setState(() {
                        if(selectedCondition != null && index == ProductCondition.values.indexOf(selectedCondition!)) {
                          selectedCondition = null;
                          if(searchController.text.isNotEmpty) {
                            searchProductsByTerm(searchController.text);
                          }else{
                            getProducts(showLoader: false);
                          }
                        }else{
                          selectedCondition = ProductCondition.values[index];
                          searchProductsByTerm(searchController.text.isNotEmpty ? searchController.text : null);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Builder(
                    builder: (context) {
                      if(((searchProducts ?? products)?.data ?? []).isEmpty && !loading){
                        return const Center(child: Text("No Auctions Available"));
                      }

                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Wrap(
                          direction: Axis.horizontal,
                          runSpacing: 2,
                          spacing: 5,
                          children: ((searchProducts ?? products)?.data ?? []).map((product) => _AuctionInfoCard(product)).toList(),
                        ),
                      );
                    }
                ),
              ]),
            )));
  }
}
