import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:kudu/core/shared_widgets/product_condition.dart';
import 'package:kudu/models/enums_and_extensions.dart';

import '../../app/locator.dart';
import '../../app/routes/routes.dart';
import '../../models/home/products_list_model.dart';
import '../../models/product.dart';
import '../../services/country_service.dart';
import '../images.dart';
import 'app_image.dart';
import 'bookmark_button.dart';

class ProductCardView2 extends StatelessWidget {
  final ProductData product;
  final double maxWidth;

  /// [ProductCardView2] implements this Figma component
  /// https://www.figma.com/design/OjLFKOOw0L8w2gqsQURFdq/Kudu-App?node-id=2055-5772&t=pSr82LIy4K42q3KI-4
  const ProductCardView2(this.product, {required this.maxWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if((product.quantity ?? 0) <=0){
          return;
        }
        ProductDetailsScreenRoute(product.id ?? "").push(context);
      },
      child: SizedBox(
        width: maxWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Stack(
                      children: [
                        AppImage(
                          imgUrl: productImages.firstOrNull ?? "",
                          radius: 10,
                          height: 176,
                          width: maxWidth,
                          fit: BoxFit.cover,
                          backgroundColor: Colors.transparent,
                        ),
                        if((product.quantity ?? 0) <=0)...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              height: 176,
                              width: maxWidth,
                              color: Colors.black.withAlpha(100),
                              child: const Center(
                                child: Text("SOLD OUT", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ImagesCountView(productImages.length ?? 0),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: BookmarkButton.outline(productId: product.id),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProductConditionBanner(product.condition?.toProductCondition ?? ProductCondition.brandNew),
                      if (product.isVerified) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7).withValues(alpha: 0.95),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF86EFAC).withValues(alpha: 0.85),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // product name and rating
            Flexible(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatProductName(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9E9E9E),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // price
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasDiscount() ? formatDiscountPrice() : formatPrice(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto",
                    color: Colors.black,
                  ),
                ),
                if (hasDiscount()) ...[
                  const SizedBox(height: 1),
                  Text(
                    formatPrice(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontFamily: "Roboto",
                    ),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatProductName() {
    return product.name ?? "";
  }

  List<String> get productImages{
    var listToReturn = <String>[];
    if(product.imageUrl != null){
      listToReturn.add(product.imageUrl ?? "");
    }
    return listToReturn;
  }

  String formatPrice() {
    final symbol = product.store?.currency?.symbol ?? locator<CountryService>().currencySymbol;
    final format = NumberFormat.currency(locale: "en-US", symbol: symbol);
    return format.format(num.tryParse(product.price ?? "") ?? 0);
  }

  String formatDiscountPrice() {
    final symbol = product.store?.currency?.symbol ?? locator<CountryService>().currencySymbol;
    final format = NumberFormat.currency(locale: "en-US", symbol: symbol);
    return format.format(num.tryParse(product.discountPrice ?? "") ?? 0);
  }

  bool hasDiscount(){
    final disc = num.tryParse(product.discountPrice ?? "") ?? 0;
    final price = num.tryParse(product.price ?? "") ?? 0;
    return disc > 0 && disc < price;
  }
}
