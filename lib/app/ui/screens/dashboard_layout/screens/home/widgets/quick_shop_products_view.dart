part of '../screen.dart';

class _QuickShopProductsView extends StatefulWidget {
  const _QuickShopProductsView();

  @override
  State<_QuickShopProductsView> createState() => _QuickShopProductsViewState();
}

class _QuickShopProductsViewState extends State<_QuickShopProductsView> {
  final _products = sampleSimilarProducts;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 19,
      spacing: 5,
      children:
          _products.map((product) => _TrendingProductCard(product)).toList(),
    );
  }
}
