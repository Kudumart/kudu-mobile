part of '../screen.dart';

class _SimilarProducts extends StatelessWidget {
  final String productID;
  final List<ProductData>? similarProducts;
  const _SimilarProducts({required this.productID,this.similarProducts});

  static const spaceBetweenChildrenOnSameRow = 13.0;

  @override
  Widget build(BuildContext context) {
    if((similarProducts ?? []).isEmpty){
      return const SizedBox();
    }
    final maxWidthPerProduct = _calculateWidthPerProduct(context);

    return Container(
        padding: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 15, UiConstant.horizontalPadding, 30),
        decoration: BoxDecoration(color: AppUiColor.ghostWhite, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Similar Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              // Text(
              //   "Browse All",
              // )
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: similarProducts?.length ?? 0,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ProductCardView2(similarProducts![index], maxWidth: maxWidthPerProduct),
                );
              },
            ),
          ),
        ],
        ),
    );
  }

  double _calculateWidthPerProduct(BuildContext context) {
    const maxChildrenPerRow = 2;

    return (MediaQuery.sizeOf(context).width - (UiConstant.horizontalPadding * 2) - spaceBetweenChildrenOnSameRow) / maxChildrenPerRow;
  }
}
