part of '../screen.dart';

class _TrendingProductPagedView extends StatefulWidget {
  const _TrendingProductPagedView();

  @override
  State<_TrendingProductPagedView> createState() =>
      _TrendingProductPagedViewState();
}

class _TrendingProductPagedViewState extends State<_TrendingProductPagedView> {
  List<_TwoProductsRowPage>? _twoProductsPerPage;
  int _activeIndex = 0;
  int length = 2;

  String? _lastCountry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentCountry = Provider.of<CountryService>(context).selectedCountryValue;
    if (_lastCountry != currentCountry) {
      _lastCountry = currentCountry;
      getProducts();
    }
  }

  ProductsListModel? products;
  Future<void> getProducts() async {
    products = await Provider.of<HomeViewModel>(context, listen: false).fetchAllProducts(
      context: context,
      isPopular: true,
      force: true,
    );
    if (products?.data?.isNotEmpty ?? false) {
      final list = products?.data ?? [];
      _twoProductsPerPage = [];
      for (var index = 0; index < list.length; index += 2) {
        final end = index + 2 < list.length ? index + 2 : list.length;
        _twoProductsPerPage!.add(
          _TwoProductsRowPage(list.sublist(index, end)),
        );
      }
      length = _twoProductsPerPage?.length ?? 2;
    } else {
      _twoProductsPerPage = [];
      length = 0;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              onPageChanged: _changeActiveIndex,
              children: _twoProductsPerPage ?? [
                _TwoProductsRowPage([ProductData(),ProductData()],loading: true),
                _TwoProductsRowPage([ProductData(),ProductData()],loading: true),
              ],
            ),
          ),
          DottedProgressIndicator(
            activeIndex: _activeIndex,
            count: _twoProductsPerPage?.length ?? length,
          ),
        ],
      ),
    );
  }

  _changeActiveIndex(int newIndex) {
    setState(() => _activeIndex = newIndex);
  }
}

class _TwoProductsRowPage extends StatelessWidget {
  final List<ProductData> products;
  final bool loading;
  const _TwoProductsRowPage(this.products,{this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ProductCardView1(products[0],isLoading: loading),
      const SizedBox(width: 10),
      if (products.length > 1) ProductCardView1(products[1],isLoading: loading),
    ]);
  }
}
