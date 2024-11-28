part of '../../../screen.dart';

class _PriceView extends StatelessWidget {
  final String formattedPrice;
  const _PriceView({required this.formattedPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.fromLTRB(12, 3, 3, 3),
      decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(14.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formattedPrice,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          const _AddButton(),
        ],
      ),
    );
  }
}
