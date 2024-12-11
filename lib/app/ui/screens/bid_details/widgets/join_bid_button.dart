part of '../screen.dart';

class _JoinBidButton extends StatefulWidget {
  final double joinPrice;
  final String currency;
  const _JoinBidButton({required this.joinPrice, required this.currency});

  @override
  State<_JoinBidButton> createState() => _JoinBidButtonState();
}

class _JoinBidButtonState extends State<_JoinBidButton> {
  late bool _joined;

  @override
  void initState() {
    super.initState();
    _joined = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppUiColor.borderline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
              text: TextSpan(
                  text: "Join Auction",
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF5F5F5F)),
                  children: [
                const WidgetSpan(child: SizedBox(width: 9)),
                TextSpan(
                    text: PriceFormatter.formatPrice(
                        price: 50000, currency: widget.currency))
              ])),
          CupertinoSwitch(
              value: _joined,
              onChanged: (joined) => setState(() => _joined = joined))
        ],
      ),
    );
  }
}
