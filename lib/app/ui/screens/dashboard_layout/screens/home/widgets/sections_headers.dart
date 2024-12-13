part of '../screen.dart';

class _TrendingHeader extends StatelessWidget {
  const _TrendingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text("Trending",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
      GestureDetector(
        onTap: () =>
            ProductSearchScreenRoute(SearchFilter(category: "Trending"))
                .push(context),
        child: const Text("See All",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppUiColor.primary)),
      )
    ]);
  }
}

class _QuickShopHeader extends StatelessWidget {
  const _QuickShopHeader();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text("Quick Shop",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
      GestureDetector(
        onTap: () => const CategoriesScreenRoute().push(context),
        child: const Text("View Categories",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppUiColor.primary)),
      )
    ]);
  }
}
