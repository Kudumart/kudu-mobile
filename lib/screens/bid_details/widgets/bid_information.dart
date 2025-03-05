part of '../screen.dart';

class _BidInformation extends StatelessWidget {
  final ProductData product;
  const _BidInformation(this.product);

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
            child: Text("Bid Information",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ),
          const SizedBox(height: 18),
          _InfoNameAndValue(
              infoName: "Minimum Bid",
              infoValue: minBid()),
          _InfoNameAndValue(
              infoName: "Time Left",
              infoValueTextColor: const Color(0xFFFF0F00),
              infoValue: timeRemaining()),
          _InfoNameAndValue(
              infoName: "Current Bid",
              infoValue: formatPrice(),
          ),
          _InfoNameAndValue(
              infoName: "Next Acceptable Bid",
              infoValue: nextAcceptableBid()),
          const SizedBox(height: 9),
          _JoinBidButton(
              joinPrice: (num.tryParse(product.bidIncrement ?? "0") ?? 0.0).toDouble(), currency: "\$"),
          const SizedBox(height: 27),
          _BidPriceInput(
            minimumPrice: (num.tryParse(product.bidIncrement ?? "0") ?? 0.0).toDouble(),
            incrementFactor: (num.tryParse(product.bidIncrement ?? "0") ?? 0.0).toDouble(),
            currency: "\$",
          ),
          const SizedBox(height: 31),
          Text(
            "*Change Factor ${minBid()}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 13),
          ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.resolveWith<Size>(
                    (_) => const Size(double.infinity, 49)),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (_) => const Color(0xFF5931FF)),
                shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
              ),
              child: const Text("SUBMIT BID AT \$8,500"))
        ],
      ),
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

  String minBid() {
    final format = NumberFormat.currency(locale: "en-US", symbol: product.store?.currency?.symbol ?? "\$");
    return format.format(num.tryParse(product.bidIncrement ?? "") ?? 0);
  }

  String maxBid() {
    return "Unlimited";
    final format = NumberFormat.currency(locale: "en-US", symbol: product.store?.currency?.symbol ?? "\$");
    return format.format(num.tryParse(product.bidIncrement ?? "") ?? 0);
  }

  String nextAcceptableBid() {
    var bidIncrement = num.tryParse(product.bidIncrement ?? "0") ?? 0.0;
    var currentBid = num.tryParse(product.price ?? "0") ?? 0.0;

    return PriceFormatter.formatPrice(
        price: (currentBid + bidIncrement).toDouble(),
        currency: product.store?.currency?.symbol ?? "\$");
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

  String timeRemaining(){
    var startDate = DateTime.tryParse(product.startDate ?? "") ?? DateTime.now();
    var endDate = DateTime.tryParse(product.endDate ?? "") ?? DateTime.now();

    var difference = endDate.difference(startDate);
    var days = difference.inDays;
    var hours = difference.inHours - (days * 24);
    var minutes = difference.inMinutes - (days * 24 * 60) - (hours * 60);

    return "$days days, $hours hours, $minutes minutes";
  }
}