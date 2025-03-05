part of '../../screen.dart';

class _AuctionInfoCard extends StatelessWidget {
  final ProductData product;
  final bool isLoading;

  const _AuctionInfoCard(this.product,{this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(isLoading){
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              //width:  _widthPerProductCard(context),
              height: context.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(11.0),
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              border: Border.all(color: AppUiColor.borderline),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ImageView(
                  imageUrls: productImages,
                  status: product.condition?.toProductCondition ?? ProductCondition.brandNew,
                  product: product,
                  showBookmarkButton: false,
                ),
              ),
              const SizedBox(height: 10),
              Text(product.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5F5F5F))),
              const SizedBox(height: 5),
              _StoreName("",store: product.store),
              const SizedBox(height: 5),
              _Location(location),
              const SizedBox(height: 7),
              // current highest bid
              RichText(
                  text: TextSpan(
                      text: "Current Bid: ",
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      children: [
                    TextSpan(
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green),
                        text: formatPrice())
                  ])),
              const SizedBox(height: 7),
              ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.resolveWith<Size>((_) => const Size(double.infinity, 36)),
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
                  ))
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
