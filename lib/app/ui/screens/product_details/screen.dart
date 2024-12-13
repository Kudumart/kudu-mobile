import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudu/app/data/storage/shared_preferences.dart';
import 'package:kudu/app/models/enums_and_extensions.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/constants.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/sample_data.dart';
import 'package:kudu/app/ui/shared_widgets/bookmark_button.dart';
import 'package:kudu/app/ui/utils/helpers.dart';

import '../../../models/product.dart';
import '../../images.dart';
import '../../shared_widgets/back_button.dart';
import '../../shared_widgets/product_card_view_2.dart';

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
  late final Product _product;

  @override
  void initState() {
    super.initState();
    _product = sampleProducts.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
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
      // body
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(0, 8, 0, 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _ImagesPreview(_product.imagesUrl),
              const SizedBox(height: 11),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: UiConstant.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LocationAndProductConditionView(
                      location: _product.location,
                      condition: _product.condition,
                    ),
                    const SizedBox(height: 20),

                    // product title
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.sizeOf(context).width * 0.2),
                      child: Text(
                        _product.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // price
                    Text(
                      _product.formatPrice(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppUiColor.primary),
                    ),
                    const SizedBox(height: 13),
                    _ContactSellerButtons(
                        sellerPhoneNumber: _product.sellerPhoneNumber),
                    const SizedBox(height: 20),
                    _Rating(_product.rating ?? 4),
                    const SizedBox(height: 13),
                    const _ShippingCost(),
                    const SizedBox(height: 18),
                    Container(color: AppUiColor.borderline, height: 1),
                    const SizedBox(height: 18),
                    Text(
                        _product.description ??
                            "Seller didn't provide any description of this product at this time. Kindly reach out to the seller to get more direct and up-to-date information about the product",
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              _SimilarProducts(
                productID: _product.id,
              )
            ],
          ),
        ),
      ),
    );
  }
}
