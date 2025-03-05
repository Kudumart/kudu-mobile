part of '../screen.dart';

class _AuctionInformation extends StatelessWidget {
  final ProductData product;
  const _AuctionInformation(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 27, 16, 22),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDDDDD)),
            borderRadius: BorderRadius.circular(7)),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Auction Information",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 18),
            _InfoNameAndValue(
              infoName: "Product",
              infoValue: product.name ?? "",
              infoValueTextColor: AppUiColor.textBlue,
            ),
            _InfoNameAndValue(infoName: "Category", infoValue: product.subCategory?.name ?? "Not Available"),
            _InfoNameAndValue(
                infoName: "Bidding Starts",
                infoValue: formatDate(DateTime.tryParse(product.startDate ?? "")?.toLocal() ?? DateTime.now(), [dd, " ", MM, ", ", yyyy])),
            _InfoNameAndValue(
                infoName: "Bidding Ends",
                infoValue: formatDate(DateTime.tryParse(product.endDate ?? "")?.toLocal() ?? DateTime.now(), [dd, " ", MM, ", ", yyyy])),
          ],
        ));
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
