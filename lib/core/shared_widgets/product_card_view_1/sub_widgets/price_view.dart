part of '../product_card_view_1.dart';

class _PriceView extends StatelessWidget {
  final String formattedPrice;
  final String? originalPrice;
  final Widget? trailingWidget;
  const _PriceView({required this.formattedPrice, this.originalPrice, this.trailingWidget});

  @override
  Widget build(BuildContext context) {
    final priceContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formattedPrice,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (originalPrice != null) ...[
          const SizedBox(height: 1),
          Text(
            originalPrice!,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );

    if (trailingWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: priceContent),
          trailingWidget!,
        ],
      );
    }

    return priceContent;
  }
}
