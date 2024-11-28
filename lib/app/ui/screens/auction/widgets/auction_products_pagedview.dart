part of '../screen.dart';

class _AuctionProductPagedView extends StatefulWidget {
  const _AuctionProductPagedView();

  @override
  State<_AuctionProductPagedView> createState() =>
      _AuctionProductPagedViewState();
}

class _AuctionProductPagedViewState extends State<_AuctionProductPagedView> {
  final List<_TwoProductsRowPage> _twoProductsPerPage = [];

  int _activeIndex = 0;
  @override
  void initState() {
    super.initState();
    int j = 0;
    const trendingProducts = sampleProducts;
    for (; j < trendingProducts.length;) {
      _twoProductsPerPage.add(_TwoProductsRowPage([
        trendingProducts[j],
        if ((j + 1) < trendingProducts.length) trendingProducts[j + 1]
      ]));
      j += 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_twoProductsPerPage.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      height: 330,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              onPageChanged: _changeActiveIndex,
              children: _twoProductsPerPage,
            ),
          ),
          DottedProgressIndicator(
            activeIndex: _activeIndex,
            count: _twoProductsPerPage.length,
          )
        ],
      ),
    );
  }

  _changeActiveIndex(int newIndex) {
    setState(() => _activeIndex = newIndex);
  }
}

class _TwoProductsRowPage extends StatelessWidget {
  final List<Product> products;
  const _TwoProductsRowPage(this.products);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _AuctionProductCard(products[0]),
      const SizedBox(width: 10),
      if (products.length > 1) _AuctionProductCard(products[1]),
    ]);
  }
}
