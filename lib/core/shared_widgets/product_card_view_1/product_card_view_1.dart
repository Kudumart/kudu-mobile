import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/shared_widgets/app_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/enums_and_extensions.dart';
import '../../../models/home/products_list_model.dart';
import '../../../models/product.dart';
import '../../colors.dart';
import '../../constants.dart';
import '../../images.dart';
import '../bookmark_button.dart';
import '../product_condition.dart';

part 'sub_widgets/image_view.dart';
part 'sub_widgets/add_button.dart';
part 'sub_widgets/location.dart';
part 'sub_widgets/price_view.dart';

class ProductCardView1 extends StatelessWidget {
  final ProductData product;
  final bool isLoading;

  /// [ProductCardView1] implements this Figma component design
  /// https://www.figma.com/design/OjLFKOOw0L8w2gqsQURFdq/Kudu-App?node-id=2669-1304&t=pSr82LIy4K42q3KI-4
  const ProductCardView1(this.product, {super.key,this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(isLoading){
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width:  _widthPerProductCard(context),
              height: context.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(11.0),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () => ProductDetailsScreenRoute(product.id ?? "").push(context),
          child: Container(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
            constraints: BoxConstraints(
                maxWidth: _widthPerProductCard(context), maxHeight: 287),
            decoration: BoxDecoration(
                border: Border.all(color: AppUiColor.borderline),
                borderRadius: BorderRadius.circular(11),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _ImageView(imageUrls: productImages, status: product.condition?.toProductCondition ?? ProductCondition.brandNew,product: product)),
                const SizedBox(height: 6),
                // title
                Text(
                  product.name ?? "",
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5F5F5F),
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                // location
                _Location(location),
                const SizedBox(height: 8),
                _PriceView(formattedPrice: formatPrice())
              ],
            ),
          ),
        );
      }
    );
  }

  double _widthPerProductCard(BuildContext context) {
    const maxSpacingBetweenProducts = 10;
    return (MediaQuery.sizeOf(context).width -
            (UiConstant.horizontalPadding * 2) -
            maxSpacingBetweenProducts) /
        2;
  }

  List<String> get productImages{
    var listToReturn = <String>[];
    if(product.imageUrl != null){
      listToReturn.add(product.imageUrl ?? "");
    }
    if(product.additionalImages != null){
      product.additionalImages?.forEach((e){
        listToReturn.add(e.toString());
      });
    }
    listToReturn = listToReturn.toSet().toList();
    return listToReturn;
  }

  String formatPrice() {
    final format = NumberFormat.currency(locale: "en-US", symbol: product.store?.currency?.symbol ?? "\$");
    return format.format(num.tryParse(product.price ?? "") ?? 0);
  }

  String get description{
    var description = product.description;
    var otherDetails = product.specification;
    if((description ?? "").isEmpty && (otherDetails ?? "").isEmpty){
      return "Seller didn't provide any description of this product at this time. Kindly reach out to the seller to get more direct and up-to-date information about the product";
    }

    return "${description?.trim()}\n\n${otherDetails?.trim()}";
  }

  String get location{
    if(product.store == null){
      return "Not Available";
    }
    if(product.store?.location == null){
      return "Not Available";
    }
    try{
      var city = product.store?.location?.city?.toString().trim() ?? "";
      var state = product.store?.location?.state?.toString().trim() ?? "";
      var country = product.store?.location?.country?.toString().trim() ?? "";

      var stringToReturn = city;
      if(city != state && state != ""){
        stringToReturn += ", $state";
      }
      if(city != country && country != ""){
        stringToReturn += ", $country";
      }
      return stringToReturn;
    }catch(_){
      return "Not Available";
    }
  }
}
