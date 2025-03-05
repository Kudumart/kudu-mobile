part of '../screen.dart';

class _QuickShopProductsView extends StatefulWidget {
  const _QuickShopProductsView();

  @override
  State<_QuickShopProductsView> createState() => _QuickShopProductsViewState();
}

class _QuickShopProductsViewState extends State<_QuickShopProductsView> {
  var loading = true;
  ProductsListModel? products;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
    });
  }

  Future<void> getProducts() async {
    products = await Provider.of<HomeViewModel>(context, listen: false).fetchAllProducts(context: context);
    loading = products?.data?.isEmpty ?? true;
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
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
            }
        ),
      );
    }
    return SizedBox(
      height: 330,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (products?.data ?? []).length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ProductCardView1(products!.data![index]),
          );
        }
      ),
    );
  }
}
