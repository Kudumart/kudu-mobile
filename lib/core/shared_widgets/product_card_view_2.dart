import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:kudu/core/shared_widgets/product_condition.dart';
import 'package:kudu/models/enums_and_extensions.dart';

import '../../app/routes/routes.dart';
import '../../models/home/products_list_model.dart';
import '../../models/product.dart';
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(margin: const EdgeInsets.only(right: 5, top: 6), child: ProductConditionBanner(product.condition?.toProductCondition ?? ProductCondition.brandNew)),
                    Container(margin: const EdgeInsets.only(right: 5, top: 6),
                      child: Container(
                        height: 24,
                        width: 69,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5), color: _backgroundColor()),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            product.isVerified ? "Verified" : "Not Verified",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: _textColor()),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  // Icon(
                  //   Icons.star,
                  //   color: product.rating != null && product.rating! > 0
                  //       ? const Color(0xFFFBBC05)
                  //       : const Color(0xFFD1D1D1),
                  //   size: 16,
                  // ),
                  // Text(
                  //   "${product.rating ?? 0.0}",
                  //   style: const TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w400,
                  //       color: Colors.black),
                  // )
                ],
              ),
            ),
            const SizedBox(height: 5),
            // price
            Text(
              hasDiscount() ? formatDiscountPrice() : formatPrice(),
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                fontFamily: "Roboto",
                color: Colors.black,
              ),
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
    final format = NumberFormat.currency(locale: "en-US", symbol: product.store?.currency?.symbol ?? "\$");
    return format.format(num.tryParse(product.price ?? "") ?? 0);
  }

  String formatDiscountPrice() {
    final format = NumberFormat.currency(locale: "en-US", symbol: product.store?.currency?.symbol ?? "\$");
    return format.format(num.tryParse(product.discountPrice ?? "") ?? 0);
  }

  bool hasDiscount(){
    if(((num.tryParse(product.discountPrice ?? "") ?? 0) > 0)){
      return true;
    }
    return false;
  }

  Color _backgroundColor() {
    if(product.isVerified) {
      return const Color(0xFF34A853);
    }else{
      return const Color.fromARGB(255, 238, 190, 15);
    }
  }

  Color _textColor() {
    if(product.isVerified) {
      return Colors.white;
    }else{
      return Colors.black;
    }
  }
}
