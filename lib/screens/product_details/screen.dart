import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/data/storage/shared_preferences.dart';
import 'package:kudu/models/chat/conversation_list.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/bookmark_button.dart';
import 'package:kudu/core/utils/helpers.dart';
import 'package:provider/provider.dart';

import '../../core/shared_widgets/app_image.dart';
import '../../core/shared_widgets/overlay/overlay.dart';
import '../../models/home/products_list_model.dart';
import '../../models/product.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../core/shared_widgets/product_card_view_2.dart';
import '../../providers/chat_view_model.dart';
import '../../providers/home_provider.dart';

part 'widgets/contact_seller_buttons.dart';
part 'widgets/location_and_usage_status.dart';
part 'widgets/cart_button.dart';
part 'widgets/images_view.dart';
part 'widgets/rating.dart';
part 'widgets/shipping_cost.dart';
part 'widgets/similar_products.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productID;
  const ProductDetailsScreen({required this.productID, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductData? product;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProduct();
    });
  }

  Future<void> getProduct() async {
    product = await Provider.of<HomeViewModel>(context, listen: false).fetchProduct(context: context, productId: widget.productID);
    if(mounted){
      setState(() {

      });
    }
  }

  List<String> get productImages{
    var listToReturn = <String>[];
    if(product != null && product?.imageUrl != null){
      listToReturn.add(product?.imageUrl ?? "");
    }
    return listToReturn;
  }

  String formatPrice() {
    final format = NumberFormat.currency(locale: "en-US", symbol: product?.store?.currency?.symbol ?? "\$");
    return format.format(num.tryParse(product?.price ?? "") ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        actions: const [
          BookmarkButton.filled(),
          SizedBox(width: 10),
          _CartButton(),
          SizedBox(
            width: UiConstant.horizontalPadding,
          )
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(0, 8, 0, 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _ImagesPreview(productImages),
              const SizedBox(height: 11),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LocationAndProductConditionView(
                      location: "",
                      condition: product?.condition?.toProductCondition ?? ProductCondition.brandNew,
                    ),
                    const SizedBox(height: 20),

                    // product title
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.sizeOf(context).width * 0.2),
                      child: Text(
                        product?.name ?? "",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // price
                    Text(
                      formatPrice(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppUiColor.primary),
                    ),
                    const SizedBox(height: 13),
                    _ContactSellerButtons(sellerPhoneNumber: product?.vendor?.phoneNumber ?? "",product: product),
                    const SizedBox(height: 20),
                    //Todo: Add rating
                    const _Rating(4),
                    const SizedBox(height: 13),
                    const _ShippingCost(),
                    const SizedBox(height: 18),
                    Container(color: AppUiColor.borderline, height: 1),
                    const SizedBox(height: 18),
                    Text(product?.description ?? "Seller didn't provide any description of this product at this time. Kindly reach out to the seller to get more direct and up-to-date information about the product",
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              _SimilarProducts(
                productID: product?.id ?? widget.productID,
              )
            ],
          ),
        ),
      ),
    );
  }
}
