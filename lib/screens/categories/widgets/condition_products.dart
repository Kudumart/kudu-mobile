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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
    });
  }

  ProductsListModel? products;
  Future<void> getProducts() async {
    products = await Provider.of<HomeViewModel>(context, listen: false).fetchProductsByCondition(context: context,condition: widget.condition.apiName,force: true);
    loading = false;
    if(mounted){
      setState(() {

      });
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
                onTap: () => ProductSearchScreenRoute(SearchFilter(category: "Trending", subCategory: widget.condition.printableName(),condition: widget.condition.apiName,isCondition: true)).push(context),
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
