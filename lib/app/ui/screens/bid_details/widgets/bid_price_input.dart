part of '../screen.dart';

class _BidPriceInput extends StatefulWidget {
  final double minimumPrice;
  final double incrementFactor;
  final String currency;
  const _BidPriceInput(
      {required this.minimumPrice,
      required this.incrementFactor,
      required this.currency});

  @override
  State<_BidPriceInput> createState() => _BidPriceInputState();
}

class _BidPriceInputState extends State<_BidPriceInput> {
  late bool _disableDecrementButton;
  late final TextEditingController _textEditingController;
  late double _currentlySetPrice;

  @override
  void initState() {
    super.initState();
    _disableDecrementButton = true;
    _currentlySetPrice = widget.minimumPrice;
    _textEditingController = TextEditingController(
        text: PriceFormatter.formatPrice(
            price: _currentlySetPrice, currency: widget.currency));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              disabledColor: AppUiColor.primary.withOpacity(0.4),
              icon: const Icon(
                CupertinoIcons.minus_circle_fill,
                size: 24,
                color: AppUiColor.primary,
              ),
              onPressed: _disableDecrementButton ? null : _decrement),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              inputFormatters: [
                MoneyInputFormatter(currencySymbol: widget.currency)
              ],
              decoration: const InputDecoration.collapsed(
                  hintText: "Enter Amount",
                  hintStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppUiColor.iconBlack)),
              style: const TextStyle(
                  fontSize: 28,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
              icon: const Icon(
                CupertinoIcons.plus_circle_fill,
                size: 24,
                color: AppUiColor.primary,
              ),
              onPressed: _increment),
        ],
      ),
    );
  }

  _increment() {
    _currentlySetPrice = widget.incrementFactor + _currentlySetPrice;

    if (_currentlySetPrice - widget.incrementFactor > widget.minimumPrice) {
      _disableDecrementButton = false;
    }
    _textEditingController.text =
        PriceFormatter.formatPrice(price: _currentlySetPrice, currency: "");
  }

  _decrement() {
    _currentlySetPrice = _currentlySetPrice - widget.incrementFactor;

    if (_currentlySetPrice <= widget.minimumPrice) {
      _disableDecrementButton = true;
    }
    _textEditingController.text =
        PriceFormatter.formatPrice(price: _currentlySetPrice, currency: "");
  }
}
