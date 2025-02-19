part of '../screen.dart';

class _AuctionSteps extends StatelessWidget {
  const _AuctionSteps();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      height: 904,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF052986),
            Color(0xFF08329E),
            Color(0xFF111F49),
          ],
          stops: [
            0.0, // change to 1.0 if needed
            0.1098, // change to 1.0 if needed
            1.0
          ], // Equivalent to percentages in CSS (0%, 10.98%, 100%)
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text("100% Online Product Auctions",
                    style: TextStyle(
                        fontSize: 17.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
                SizedBox(height: 11),
                Text(
                    "Over 1 Million Used, Wholesale and Refurbished products up for grabs!",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
                SizedBox(height: 12),
                _AuctionStep(
                    number: 1,
                    name: "Register",
                    explanation:
                        "Sign up for a Kudu account and become a verified user"),
                SizedBox(height: 23),
                _AuctionStep(
                    number: 2,
                    name: "Find",
                    explanation:
                        "Search our inventory of more than 256,894 used and refurbished goods"),
                SizedBox(height: 23),
                _AuctionStep(
                    number: 3,
                    name: "Bid",
                    explanation:
                        "Bid on daily product auctions from  Monday- Friday."),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Image.asset(AppUiImage.auctionAdsCars))
        ],
      ),
    );
  }
}
