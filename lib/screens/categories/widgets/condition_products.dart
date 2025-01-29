part of '../screen.dart';

class _ConditionProducts extends StatelessWidget {
  final ProductCondition condition;
  final List<Product> products;
  const _ConditionProducts({
    required this.condition,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 208),
      padding: const EdgeInsets.fromLTRB(11, 12, 12, 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(condition.printableName().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: () => ProductSearchScreenRoute(SearchFilter(
                        category: "Trending",
                        subCategory: condition.printableName()))
                    .push(context),
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
          Row(children: [
            Flexible(
                flex: 1,
                child: LayoutBuilder(
                    builder: (_, constraints) => _ProductCard(products.first,
                        maxWidth: constraints.maxWidth))),
            const SizedBox(width: 10),
            Flexible(
                flex: 1,
                child: LayoutBuilder(builder: (_, constraints) {
                  if (products.length < 2) {
                    return SizedBox(width: constraints.maxWidth);
                  }
                  return _ProductCard(products.last,
                      maxWidth: constraints.maxWidth);
                })),
          ])
        ],
      ),
    );
  }
}
