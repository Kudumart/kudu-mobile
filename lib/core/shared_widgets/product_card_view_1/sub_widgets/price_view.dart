part of '../product_card_view_1.dart';

class _PriceView extends StatelessWidget {
  final String formattedPrice;
  final Widget? trailingWidget;
  const _PriceView({required this.formattedPrice, this.trailingWidget});

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
          Expanded(
            child: Text(formattedPrice,
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if(trailingWidget != null)...[
            trailingWidget!,
          ]else...[
            const _AddButton(),
          ]
        ],
      ),
    );
  }
}
