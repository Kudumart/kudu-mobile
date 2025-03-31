import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/models/bookmarked_product.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/utils/price_formatter.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import '../../models/home/cart_list_model.dart';
import '../../models/home/products_list_model.dart';
import '../../providers/home_provider.dart';

part 'widgets/bookmarked_product_card.dart';

class BookmarkedProductsScreen extends StatefulWidget {
  const BookmarkedProductsScreen({super.key});

  @override
  State<BookmarkedProductsScreen> createState() =>
      _BookmarkedProductsScreenState();
}

class _BookmarkedProductsScreenState extends State<BookmarkedProductsScreen> {
  CartListModel? products;
  bool loading = false;
  late HomeViewModel provider;

  @override
  initState() {
    super.initState();
    provider = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
    });
  }

  Future<void> getProducts({String? searchTerm}) async {
    if(mounted){
      setState(() {
        loading = true;
      });
    }
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    products = await provider.fetchSavedProducts(context: context);
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (c,result){
        Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Bookmarked Products",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            centerTitle: false,
            titleSpacing: 0,
            leading: AppBackButton(
              onPressed: (){
                Navigator.of(context).pop();
                Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
              },
            ),
          ),
          body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 0, UiConstant.horizontalPadding, 10),
            child: Builder(
                builder: (context) {
                  if((products?.data ?? []).isEmpty && !loading){
                    return const Center(child: Text("No Products In Cart"));
                  }

                  return SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 19,
                      spacing: 5,
                      children: (products?.data ?? []).map((product) => BookmarkItem(
                        key: ValueKey(product.id),
                        product: product.product!,
                        onRemoved: () async {
                          var provider = Provider.of<HomeViewModel>(context, listen: false);
                          await provider.removeProductFromBookmarks(context: context, productId: product.id ?? "");
                          getProducts();
                        },
                      )).toList(),
                    ),
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
}

class BookmarkItem extends StatefulWidget {
  const BookmarkItem({
    super.key,
    required this.product, this.onRemoved,
  });
  final ProductData product;
  final Function()? onRemoved;

  @override
  State<BookmarkItem> createState() => _BookmarkItemState();
}

class _BookmarkItemState extends State<BookmarkItem> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProductCardView1(
          widget.product,
        ),
        /*Padding(
          padding: const EdgeInsets.all(6.0),
          child: InkWell(
            onTap: () {
              widget.onRemoved?.call();
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: AppUiColor.primary,
                size: 20,
              ),
            ),
          ),
        ),*/
      ],
    );
  }
}
