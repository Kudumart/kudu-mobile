part of '../screen.dart';

class _CheckoutCalculator extends StatelessWidget {
  const _CheckoutCalculator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CalculatorEntry(label: "Sub-total", formattedPrice: "\$1,247"),
        const SizedBox(height: 10),
        const _CalculatorEntry(label: "VAT (%)", formattedPrice: "\$0.00"),
        const SizedBox(height: 10),
        const _CalculatorEntry(label: "Shipping fee", formattedPrice: "\$4800"),
        const SizedBox(height: 15),
        Container(color: AppUiColor.borderline, height: 1),
        const SizedBox(height: 10),
        const _CalculatorEntry(label: "Total", formattedPrice: "\$1,251"),
      ],
    );
  }
}

class _CalculatorEntry extends StatelessWidget {
  final String label;
  final String formattedPrice;
  const _CalculatorEntry({required this.label, required this.formattedPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
        Text(formattedPrice,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
