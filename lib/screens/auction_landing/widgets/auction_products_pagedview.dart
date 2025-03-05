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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
    });
  }

  ProductsListModel? products;
  Future<void> getProducts() async {
    products = await Provider.of<HomeViewModel>(context, listen: false).fetchAllAuctionProducts(context: context,force: true);
    if(products?.data?.isNotEmpty ?? false){
      var list = products?.data ?? [];
      if(list.length >= 4){
        _twoProductsPerPage = [];
        _twoProductsPerPage!.add(_TwoProductsRowPage([list[0],list[1]]));
        _twoProductsPerPage!.add(_TwoProductsRowPage([list[2],list[3]]));
      }else if(list.length == 3) {
        _twoProductsPerPage = [];
        _twoProductsPerPage!.add(_TwoProductsRowPage([list[0], list[1]]));
        _twoProductsPerPage!.add(_TwoProductsRowPage([list[2]]));
      }else if(list.length == 2) {
        _twoProductsPerPage = [];
        _twoProductsPerPage!.add(_TwoProductsRowPage([list[0], list[1]]));
      }else if(list.length == 1) {
        _twoProductsPerPage = [];
        _twoProductsPerPage!.add(_TwoProductsRowPage([list[0]]));
      }
      length = _twoProductsPerPage?.length ?? 2;
    }
    if(mounted){
      setState(() {

      });
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
