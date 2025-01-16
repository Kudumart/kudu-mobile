part of '../../screen.dart';

class _AuctionInfoCard extends StatelessWidget {
  final Auction auction;
  const _AuctionInfoCard(this.auction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    auction.name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5F5F5F)),
                  ),
                  const SizedBox(height: 5),
                  _Location(auction.location)
                ],
              ),
              const SizedBox(width: 12),
              _StoreName(auction.storeID)
            ],
          ),
          const SizedBox(height: 12),

          // image and details
          Expanded(
            child: Row(
              children: [
                Flexible(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(auction.image,
                          height: 156, fit: BoxFit.cover),
                    )),
                const SizedBox(width: 20),
                Flexible(
                    flex: 5,
                    child: _SpecsAndBidPrice(
                      bidPrice: PriceFormatter.formatPrice(
                          price: auction.currentHighestBid, currency: "\$"),
                      specification: auction.specification,
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
                      BidDetailsScreenRoute(auction).push(context);
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
}
