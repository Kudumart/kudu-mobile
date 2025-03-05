part of '../../screen.dart';

class _AuctionInfoCard extends StatelessWidget {
  final ProductData product;
  final bool isLoading;
  const _AuctionInfoCard(this.product, {super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(isLoading){
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width:  350,
              height: context.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(11.0),
              ),
            ),
          );
        }

        return Container(
          height: 350,
          margin: const EdgeInsets.only(
              bottom: 22,
              right: UiConstant.horizontalPadding,
              left: UiConstant.horizontalPadding),
          padding: const EdgeInsets.fromLTRB(19, 20, 15, 13),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFDDDDDD)),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40C9C9C9),
                  offset: Offset(0, 4),
                  blurRadius: 18,
                  spreadRadius: 0,
                )
              ]),
          child: Column(
            children: [
              // title, location, and store name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title and location
                  SizedBox(
                    width: context.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name ?? "",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF5F5F5F)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        _Location(location)
                      ],
                    ),
                  ),
                  20.width,
                  Expanded(child: _StoreName(product.store?.id ?? "",store: product.store))
                ],
              ),
              const SizedBox(height: 12),

              // image and details
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 4,
                      child: SizedBox(
                        //height: 156,
                        child: ImageView(
                          imageUrls: productImages,
                          status: product.condition?.toProductCondition ?? ProductCondition.brandNew,
                          product: product,
                          showBookmarkButton: false,
                        ),
                      ),
                    ),
                    10.width,
                    Flexible(
                        flex: 5,
                        child: _SpecsAndBidPrice(
                          bidPrice: formatPrice(),
                          specification: specs,
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // buttons
              Row(
                children: [
                  // view details button
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                              (_) => AppUiColor.primary),
                          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                              (_) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7))),
                          minimumSize: WidgetStateProperty.resolveWith<Size>(
                              (_) => const Size(double.infinity, 42)),
                        ),
                        onPressed: () {
                          BidDetailsScreenRoute(product).push(context);
                        },
                        child: const Text(
                          "View Details",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                  const SizedBox(width: 8),

                  // bid now button
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                              (_) => const Color(0xFF1254FF)),
                          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                              (_) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7))),
                          minimumSize: WidgetStateProperty.resolveWith<Size>(
                              (_) => const Size(double.infinity, 42)),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Bid Now",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ],
              )
            ],
          ),
        );
      }
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
