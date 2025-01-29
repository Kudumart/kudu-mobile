part of '../../screen.dart';

class _AuctionInfoCard extends StatelessWidget {
  final Auction auction;

  const _AuctionInfoCard(this.auction);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          border: Border.all(color: AppUiColor.borderline),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ImageView(
                imageUrls: [auction.image, ...auction.additionalImages],
                condition: auction.condition),
          ),
          const SizedBox(height: 10),
          Text(auction.name,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5F5F5F))),
          const SizedBox(height: 5),
          _StoreName(auction.storeID),
          const SizedBox(height: 5),
          _Location(auction.location),
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
                    text: PriceFormatter.formatPrice(
                        price: auction.currentHighestBid, currency: "\$"))
              ])),
          const SizedBox(height: 7),
          ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.resolveWith<Size>(
                    (_) => const Size(double.infinity, 36)),
              ),
              onPressed: () {
                BidDetailsScreenRoute(auction).push(context);
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
}
