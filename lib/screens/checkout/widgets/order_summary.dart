part of '../screen.dart';

class _OrderSummary extends StatelessWidget {
  final OrderSummary orderSummary;
  const _OrderSummary(this.orderSummary);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 273,
      padding: const EdgeInsets.fromLTRB(21, 18, 20, 17),
      decoration: BoxDecoration(
          color: AppUiColor.grey50,
          border: Border.all(color: const Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(11)),
      child: Column(
        children: [
          _OrderSummaryEntry(
              label: "Item's Total",
              formattedPrice: PriceFormatter.formatPrice(
                  price: orderSummary.subTotal,
                  currency: orderSummary.currency)),
          const SizedBox(height: 13),
          _OrderSummaryEntry(
              label: "Delivery Fees",
              formattedPrice: PriceFormatter.formatPrice(
                  price: orderSummary.shippingPrice,
                  currency: orderSummary.currency)),
          const SizedBox(height: 13),
          _OrderSummaryEntry(
              label: "VAT (%)",
              formattedPrice: PriceFormatter.formatPrice(
                  price: orderSummary.vat, currency: orderSummary.currency)),
          const SizedBox(height: 16),
          const CustomDivider(
            withoutMargin: true,
          ),
          const SizedBox(height: 17),

          // total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              Text(
                  PriceFormatter.formatPrice(
                      price: orderSummary.total(),
                      currency: orderSummary.currency),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 17),

          const CustomDivider(
            withoutMargin: true,
          ),
          const SizedBox(height: 30),
          const _CouponEntry()
        ],
      ),
    );
  }
}

class _OrderSummaryEntry extends StatelessWidget {
  final String label;
  final String formattedPrice;
  const _OrderSummaryEntry({required this.label, required this.formattedPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 14,
                fontWeight: FontWeight.w300)),
        Text(formattedPrice,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400)),
      ],
    );
  }
}

class _CouponEntry extends StatelessWidget {
  const _CouponEntry();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                prefixIconConstraints:
                    const BoxConstraints(maxHeight: 24, maxWidth: 47),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 17.0, right: 10),
                  child: SvgPicture.asset(
                    AppUiIcon.coupon,
                    colorFilter: const ColorFilter.mode(
                        AppUiColor.primary, BlendMode.srcIn),
                  ),
                ),
                hintText: "Enter coupon code",
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                hintStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE7E7E7))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE7E7E7))),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
              onPressed: () {},
              child: const Text("APPLY",
                  style: TextStyle(
                      color: Color(0xFF939393),
                      fontSize: 14,
                      fontWeight: FontWeight.w400))),
        ],
      ),
    );
  }
}

class _OrderSummaryHeader extends StatelessWidget {
  const _OrderSummaryHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Order Summary",
            style: TextStyle(
                color: Color(0xFF9e9e9e),
                fontWeight: FontWeight.w400,
                fontSize: 14)),
        Text("See Details >",
            style: TextStyle(
                color: AppUiColor.textBlue,
                fontSize: 13,
                fontWeight: FontWeight.w400)),
      ],
    );
  }
}
