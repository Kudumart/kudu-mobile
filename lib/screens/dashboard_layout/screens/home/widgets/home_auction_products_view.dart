part of '../screen.dart';

class _HomeAuctionProductsView extends StatefulWidget {
  const _HomeAuctionProductsView();

  @override
  State<_HomeAuctionProductsView> createState() => _HomeAuctionProductsViewState();
}

class _HomeAuctionProductsViewState extends State<_HomeAuctionProductsView> {
  var loading = true;
  ProductsListModel? products;
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

  Future<void> getProducts() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    products = await Provider.of<HomeViewModel>(context, listen: false).fetchAllAuctionProducts(
      context: context,
      force: true,
    );
    loading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: 330,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ProductCardView1(ProductData(), isLoading: true),
              );
            }),
      );
    }

    final rawList = products?.data ?? [];
    final productList = rawList.where((p) => p.isAuction == true || p.auctionStatus != null).toList();
    if (productList.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 330,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ProductCardView1(product),
          );
        },
      ),
    );
  }
}
