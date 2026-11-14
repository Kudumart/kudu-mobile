part of '../product_card_view_1.dart';

class _PriceView extends StatelessWidget {
  final String formattedPrice;
  final String? originalPrice;
  final Widget? trailingWidget;
  const _PriceView({required this.formattedPrice, this.originalPrice, this.trailingWidget});

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
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedPrice,
                    style: TextStyle(
                      fontSize: trailingWidget != null ? 12 : 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                  ),
                  if (originalPrice != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      originalPrice!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ],
              ),
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
