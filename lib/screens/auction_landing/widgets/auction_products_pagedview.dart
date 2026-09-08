part of '../screen.dart';

class _AuctionProductPagedView extends StatefulWidget {
  const _AuctionProductPagedView();

  @override
  State<_AuctionProductPagedView> createState() =>
      _AuctionProductPagedViewState();
}

class _AuctionProductPagedViewState extends State<_AuctionProductPagedView> {
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
    products = await Provider.of<HomeViewModel>(context, listen: false).fetchAllAuctionProducts(context: context, force: true);
    if (products?.data?.isNotEmpty ?? false) {
      var list = products?.data ?? [];
      _twoProductsPerPage = [];
      for (int i = 0; i < list.length; i += 2) {
        if (i + 1 < list.length) {
          _twoProductsPerPage!.add(_TwoProductsRowPage([list[i], list[i + 1]]));
        } else {
          _twoProductsPerPage!.add(_TwoProductsRowPage([list[i]]));
        }
      }
      length = _twoProductsPerPage?.length ?? 0;
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
    // if (_twoProductsPerPage?.isEmpty ?? true) {
    //   return const SizedBox();
    // }
    return SizedBox(
      height: 325,
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
          const SizedBox(height: 15),
          DottedProgressIndicator(
            activeIndex: _activeIndex,
            count: _twoProductsPerPage?.length ?? 2,
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
  final List<ProductData> auctionAds;
  final bool loading;
  const _TwoProductsRowPage(this.auctionAds,{this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(flex: 1, child: _AuctionInfoCard(auctionAds[0],isLoading: loading)),
      const SizedBox(width: 10),
      Flexible(
          flex: 1,
          child: auctionAds.length > 1
              ? _AuctionInfoCard(auctionAds[1],isLoading: loading)
              : const SizedBox()),
    ]);
  }
}
