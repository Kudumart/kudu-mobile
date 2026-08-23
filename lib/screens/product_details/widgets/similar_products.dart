part of '../screen.dart';

class _SimilarProducts extends StatelessWidget {
  final String productID;
  final List<ProductData>? similarProducts;
  const _SimilarProducts({required this.productID,this.similarProducts});

  static const spaceBetweenChildrenOnSameRow = 13.0;

  @override
  Widget build(BuildContext context) {
    final filtered = (similarProducts ?? []).where((p) => p.id != productID).toList();
    if(filtered.isEmpty){
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
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ProductCardView2(filtered[index], maxWidth: maxWidthPerProduct),
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

class _VendorProductsSection extends StatelessWidget {
  final String productID;
  final List<ProductData>? vendorProducts;
  const _VendorProductsSection({required this.productID, this.vendorProducts});

  static const spaceBetweenChildrenOnSameRow = 13.0;

  @override
  Widget build(BuildContext context) {
    final filtered = (vendorProducts ?? []).where((p) => p.id != productID).toList();
    if(filtered.isEmpty){
      return const SizedBox();
    }
    final maxWidthPerProduct = _calculateWidthPerProduct(context);

    return Container(
        padding: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 15, UiConstant.horizontalPadding, 20),
        decoration: BoxDecoration(color: AppUiColor.ghostWhite, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("More from this Store", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ProductCardView2(filtered[index], maxWidth: maxWidthPerProduct),
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
