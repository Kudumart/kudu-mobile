part of '../screen.dart';

class _BidInformation extends StatelessWidget {
  final Auction auction;
  const _BidInformation(this.auction);

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
              infoValue: PriceFormatter.formatPrice(
                  price: auction.minimumBidPrice, currency: "\$")),
          _InfoNameAndValue(
              infoName: "Time Left",
              infoValueTextColor: const Color(0xFFFF0F00),
              infoValue: auction.formattedTimeLeft()),
          _InfoNameAndValue(
              infoName: "Current Bid",
              infoValue: PriceFormatter.formatPrice(
                  price: auction.currentHighestBid, currency: "\$")),
          _InfoNameAndValue(
              infoName: "Next Acceptable Bid",
              infoValue: PriceFormatter.formatPrice(
                  price: auction.currentHighestBid +
                      (auction.bidIncrement ?? 1),
                  currency: "\$")),
          const SizedBox(height: 9),
          _JoinBidButton(
              joinPrice: auction.participantsInterestFee, currency: "\$"),
          const SizedBox(height: 27),
          _BidPriceInput(
              minimumPrice: auction.minimumBidPrice,
              incrementFactor: auction.bidIncrement ?? 10,
              currency: "\$"),
          const SizedBox(height: 31),
          Text(
            "*Change Factor ${PriceFormatter.formatPrice(price: auction.bidIncrement ?? 1, currency: "\$")}",
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
}