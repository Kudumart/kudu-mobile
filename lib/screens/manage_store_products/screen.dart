import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/images.dart';

import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:kudu/models/get_product_model.dart';
import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../models/enums_and_extensions.dart';
import '../../models/product.dart';
import '../../models/store.dart';
import '../../app/routes/routes.dart';

part 'widgets/product_card.dart';
part 'widgets/checkout_calculator.dart';
part 'widgets/quantity_mutator.dart';
part 'widgets/edit_button.dart';

class StoreProductsScreen extends StatefulWidget {
  final GetStoreModel store;
  const StoreProductsScreen(this.store, {super.key});

  @override
  State<StoreProductsScreen> createState() => _StoreProductsScreenState();
}

class _StoreProductsScreenState extends State<StoreProductsScreen> {
  // final List<Product> products = [
  //   ...sampleProducts,
  //   ...sampleProducts,
  //   ...sampleProducts
  // ];

  late final GetProductModel product;

  @override
  void initState() {
    super.initState();
    product = GetProductModel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }

  void getProducts(){
    Provider.of<StoreViewModel>(context, listen: false).getVendorsProducts(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AddProductScreenRoute(
            product,
            storeId: widget.store.id!,
            isEditing: false,
          ).push(context);
          getProducts();
        },
        backgroundColor: AppUiColor.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
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
      // _isLoading
      //     ? ListView.separated(
      //         padding: const EdgeInsets.all(0),
      //         itemBuilder: (context, index) => ShimmerProductCard(),
      //         separatorBuilder: (_, __) => const SizedBox(height: 14),
      //         itemCount: model.getproductsModel
      //             .length, // Show 5 shimmer cards while loading
      //       )
      //     :
      body: Consumer<StoreViewModel>(builder: (context, model, child) {
        return SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 24, UiConstant.horizontalPadding, 10),
          child: Builder(
                builder: (context) {
                  var hasProducts = model.getproductsModel.any((element) => element.storeId == widget.store.id);
                  if(!hasProducts || model.getproductsModel.isEmpty){
                    return const Center(
                      child: Text("No products found"),
                    );
                  }
                  return ListView.separated(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        final products = model.getproductsModel[index];
                        return _CartProductCard(products, widget.store);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemCount: model.getproductsModel.length,
                    );
                }
              ),
        );
      }),
    );
  }
}
