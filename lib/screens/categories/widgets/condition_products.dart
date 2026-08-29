part of '../screen.dart';

class _ConditionProducts extends StatefulWidget {
  final ProductCondition condition;

  const _ConditionProducts({
    required this.condition,
  });

  @override
  State<_ConditionProducts> createState() => _ConditionProductsState();
}

class _ConditionProductsState extends State<_ConditionProducts> {
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
    products = await Provider.of<HomeViewModel>(context, listen: false).fetchProductsByCondition(
      context: context,
      condition: widget.condition.apiName,
      force: true,
    );
    loading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 208),
      padding: const EdgeInsets.fromLTRB(11, 12, 12, 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.condition.printableName().toUpperCase(), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: () => ProductSearchScreenRoute(SearchFilter(category: widget.condition.printableName(), subCategory: widget.condition.printableName(),condition: widget.condition.apiName,isCondition: true)).push(context),
                child: const Text(
                  "SEE ALL",
                  style: TextStyle(
                      color: AppUiColor.primary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          const CustomDivider(withoutMargin: true),
          const SizedBox(height: 17),
          SizedBox(
            height: 220,
            child: Builder(
              builder: (context) {
                if(loading){
                  return ListView.builder(
                    itemCount: 2,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(padding: const EdgeInsets.only(right: 8),child: _ProductCard(ProductData(), maxWidth: context.width * 0.4,loading: loading,));
                    },
                  );
                }else if(products?.data == null || products!.data!.isEmpty){
                  return const Center(child: Text("No products found"));
                }
                return ListView.builder(
                  itemCount: products?.data?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(padding: const EdgeInsets.only(right: 8),child: _ProductCard(products!.data![index], maxWidth: context.width * 0.4));
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
