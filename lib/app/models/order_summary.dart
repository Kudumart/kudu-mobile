class OrderSummary {
  final String currency;
  final double subTotal;
  final double vat;
  final double shippingPrice;

  OrderSummary({
    required this.currency,
    required this.subTotal,
    required this.vat,
    required this.shippingPrice,
  });

  double total() {
    return subTotal + vat + shippingPrice;
  }
}
