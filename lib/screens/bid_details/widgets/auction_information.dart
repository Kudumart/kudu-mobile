part of '../screen.dart';

class _AuctionInformation extends StatelessWidget {
  final Auction auction;
  const _AuctionInformation(this.auction);

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
              infoValue: auction.name,
              infoValueTextColor: AppUiColor.textBlue,
            ),
            const _InfoNameAndValue(infoName: "Category", infoValue: "Vehicel"),
            _InfoNameAndValue(
                infoName: "Bidding Starts",
                infoValue:
                    formatDate(auction.starts, [dd, " ", MM, ", ", yyyy])),
            _InfoNameAndValue(
                infoName: "Bidding Ends",
                infoValue: formatDate(auction.ends, [dd, " ", MM, ", ", yyyy])),
          ],
        ));
  }
}
