import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/shared_widgets/avatar.dart';
import 'package:kudu/core/utils/price_formatter.dart';
import 'package:kudu/core/utils/textfield_input_formatters.dart';
import 'package:kudu/providers/auth_provider.dart';
import 'package:kudu/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import '../../models/auction.dart';
import '../../models/enums_and_extensions.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../models/home/products_list_model.dart';

part 'widgets/image_view.dart';
part 'widgets/bid_information.dart';
part 'widgets/bid_price_input.dart';
part 'widgets/join_bid_button.dart';
part 'widgets/auction_information.dart';
part 'widgets/key_value_pair_viewer.dart';
part 'widgets/vendor_information.dart';

class BidDetailsScreen extends StatelessWidget {
  final ProductData product;
  const BidDetailsScreen(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const AppBackButton(),
            titleSpacing: 0,
            title: Text(product.name ?? "", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            centerTitle: false,
            forceMaterialTransparency: true,
          ),
          body: SafeArea(
            minimum: const EdgeInsets.only(top: 10, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: ImageView(
                      imageUrls: productImages,
                      status: product.condition?.toProductCondition ?? ProductCondition.brandNew,
                      product: product,
                      showBookmarkButton: false,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: UiConstant.horizontalPadding),
                  //   child: _ImageView(
                  //       imageUrls: [product.image, ...product.additionalImages],
                  //       status: product.status()),
                  // ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: UiConstant.horizontalPadding),
                    child: Column(
                      children: [
                        _AuctionInformation(product),
                        const SizedBox(height: 26),
                        _BidInformation(product),
                        const SizedBox(height: 26),
                        _VendorInformation("",store: product.store),
                        const SizedBox(height: 26),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              minimumSize:
                                  WidgetStateProperty.resolveWith<Size>(
                                      (_) => const Size(double.infinity, 49)),
                              visualDensity:
                                  VisualDensity.adaptivePlatformDensity,
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (_) => const Color(0xFFFF0F00)),
                              shape: WidgetStateProperty.resolveWith<
                                      OutlinedBorder>(
                                  (_) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7))),
                            ),
                            child: const Text("Leave this Auction"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
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

  Map<String, dynamic> get specs{
    return {
      "Condition": product.condition?.toProductCondition.printableName(),
      "Current Bid": product.price != null ? formatPrice() : "No Bids Yet",
      "Status": product.auctionStatus?.capitalizeFirst ?? "Not Started",
    };
  }
}
