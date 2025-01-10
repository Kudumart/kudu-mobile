part of '../screen.dart';

class _ShippingCost extends StatelessWidget {
  const _ShippingCost();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.local_shipping, color: Colors.grey),
        SizedBox(width: 4),
        Text(
          '+ ₦2,500 Shipping cost',
          style: TextStyle(
            fontFamily: "Roboto",
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
