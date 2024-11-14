part of '../screen.dart';

class _TrendingItemView extends StatelessWidget {
  final TrendingItem item;
  const _TrendingItemView(this.item);

  @override
  Widget build(BuildContext context) {
    return item.isBanner
        ? Image.asset(
            (item as TrendingItemBanner).url,
            height: 162,
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.cover,
          )
        : _TrendingItemProductView(item as TrendingItemProduct);
  }
}

class _TrendingItemProductView extends StatelessWidget {
  final TrendingItemProduct item;
  const _TrendingItemProductView(this.item);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      item.url,
      height: 230,
      width: MediaQuery.sizeOf(context).width,
      fit: BoxFit.cover,
    );
  }
}
