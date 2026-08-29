part of '../screen.dart';

class _QuickShopProductsView extends StatefulWidget {
  const _QuickShopProductsView();

  @override
  State<_QuickShopProductsView> createState() => _QuickShopProductsViewState();
}

class _QuickShopProductsViewState extends State<_QuickShopProductsView> {
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
    products = await Provider.of<HomeViewModel>(context, listen: false).fetchAllProducts(
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

    final productList = products?.data ?? [];
    if (productList.isEmpty) {
      final selectedCountry = Provider.of<CountryService>(context, listen: false).selectedCountry;
      return Container(
        height: 140,
        margin: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront_outlined, size: 36, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              "No products listed in ${selectedCountry.label} (${selectedCountry.value}) yet.",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 330,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ProductCardView1(productList[index]),
          );
        },
      ),
    );
  }
}
