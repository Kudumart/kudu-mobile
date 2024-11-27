part of '../screen.dart';

class _SimilarProducts extends StatelessWidget {
  final String productID;
  const _SimilarProducts({required this.productID});

  static const spaceBetweenChildrenOnSameRow = 13.0;

  @override
  Widget build(BuildContext context) {
    final maxWidthPerProduct = _calculateWidthPerProduct(context);

    return Container(
        padding: const EdgeInsets.fromLTRB(
            UiConstant.horizontalPadding, 15, UiConstant.horizontalPadding, 30),
        decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(15)),
        child: Column(children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Similar Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              Text(
                "Browse All",
              )
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            verticalDirection: VerticalDirection.down,
            runAlignment: WrapAlignment.start,
            runSpacing: 10,
            spacing: spaceBetweenChildrenOnSameRow,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              ProductCardView2(sampleSimilarProducts.first,
                  maxWidth: maxWidthPerProduct),
              ProductCardView2(sampleSimilarProducts.last,
                  maxWidth: maxWidthPerProduct)
            ],
          )
        ]));
  }

  double _calculateWidthPerProduct(BuildContext context) {
    const maxChildrenPerRow = 2;

    return (MediaQuery.sizeOf(context).width -
            (UiConstant.horizontalPadding * 2) -
            spaceBetweenChildrenOnSameRow) /
        maxChildrenPerRow;
  }
}
