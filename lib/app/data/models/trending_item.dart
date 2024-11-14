abstract class TrendingItem {
  final bool isBanner;

  TrendingItem({required this.isBanner});
}

class TrendingItemProduct extends TrendingItem {
  final String url;

  TrendingItemProduct({required this.url, super.isBanner = false});
}

class TrendingItemBanner extends TrendingItem {
  final String url;

  TrendingItemBanner({required this.url, super.isBanner = true});
}
