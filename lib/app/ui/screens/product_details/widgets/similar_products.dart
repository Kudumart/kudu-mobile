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
              _SimilarProductCard(sampleSimilarProducts.first,
                  maxWidth: maxWidthPerProduct),
              _SimilarProductCard(sampleSimilarProducts.last,
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

class _SimilarProductCard extends StatelessWidget {
  final Product product;
  final double maxWidth;
  const _SimilarProductCard(this.product, {required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image preview
          (product.imagesUrl == null || product.imagesUrl!.isEmpty)
              ? Image.asset(AppUiImage.brokenImageIcon,
                  height: 176, width: maxWidth, fit: BoxFit.cover)
              : Image.asset(product.imagesUrl!.first,
                  height: 176, width: maxWidth, fit: BoxFit.cover),
          const SizedBox(height: 15),

          // product name and rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatProductName(),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9E9E9E)),
              ),
              const Expanded(child: SizedBox()),
              Icon(
                Icons.star,
                color: product.rating != null && product.rating! > 0
                    ? const Color(0xFFFBBC05)
                    : const Color(0xFFD1D1D1),
                size: 16,
              ),
              const SizedBox(width: 3),
              Text(
                "${product.rating ?? 0.0}",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              )
            ],
          ),
          const SizedBox(height: 5),

          // price
          Text(
            product.formatPrice(),
            style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                fontFamily: "Roboto",
                color: Colors.black),
          )
        ],
      ),
    );
  }

  String _formatProductName() {
    if (product.name.length > 18) {
      return product.name.substring(0, 18);
    }

    return product.name;
  }
}
