import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/data/models/trending_item.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/constants.dart';
import 'package:kudu/app/ui/images.dart';

part 'widgets/app_bar.dart';
part 'widgets/search_bar.dart';
part 'widgets/banners.dart';
part 'widgets/usage_categories.dart';
part 'widgets/categories_header.dart';
part 'widgets/trending_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                const _AppBar(
                    username: "Dwaelo", userAvatar: UiImage.userAvatar),
                const SizedBox(height: 24),
                const _SearchBar(),
                const SizedBox(height: 23),
                const _Banners(),
                const SizedBox(height: 22),

                // divider
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: UiConstant.horizontalPadding),
                    color: UiColor.borderline,
                    height: 1),
                const SizedBox(height: 18),
                const _UsageCategories(),
                const SizedBox(height: 14),
                SizedBox(
                  width: 40,
                  child: LinearProgressIndicator(
                      minHeight: 4,
                      value:
                          0.6, // Set the progress value (between 0.0 and 1.0)
                      backgroundColor: Colors.grey[300], // Background color
                      borderRadius: BorderRadius.circular(8),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.orange)),
                ),
                const SizedBox(height: 45),
                const _CategoriesHeader(),
                const SizedBox(height: 9),
                ...[
                  TrendingItemProduct(url: UiImage.trendingProduct1),
                  TrendingItemProduct(url: UiImage.trendingProduct2),
                  TrendingItemProduct(url: UiImage.trendingProduct3),
                  TrendingItemProduct(url: UiImage.trendingProduct4),
                  TrendingItemBanner(url: UiImage.trendingBanner)
                ].map<Widget>((item) => _TrendingItemView(item))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LowerContainer extends StatelessWidget {
  const _LowerContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          UiConstant.horizontalPadding, 23, UiConstant.horizontalPadding, 10),
      decoration: BoxDecoration(
          color: UiColor.borderline, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const _Services(),
          const SizedBox(height: 29),

          // divider
          Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: UiConstant.horizontalPadding),
              color: UiColor.borderline,
              height: 1),
              const SizedBox(height: 25),
              const _CategoriesHeader()
        ],
      ),
    );
  }
}

class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ServiceIcon(
            outline: UiColor.primary.withOpacity(0.32),
            background: UiColor.primary.withOpacity(0.14),
            label: "Auction",
            iconAssetUrl: UiIcon.auction),
        _ServiceIcon(
            outline: UiColor.primary.withOpacity(0.32),
            background: UiColor.primary.withOpacity(0.14),
            label: "Jobs",
            iconAssetUrl: UiIcon.jobs),
        _ServiceIcon(
            outline: const Color(0xFF4CD964).withOpacity(0.30),
            background: const Color(0xFF4CD964).withOpacity(0.15),
            label: "Auction",
            iconAssetUrl: UiIcon.auction),
      ],
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  final Color background;
  final String iconAssetUrl;
  final String label;
  final Color outline;
  const _ServiceIcon(
      {required this.outline,
      required this.background,
      required this.label,
      required this.iconAssetUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 89,
          width: 85,
          decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: Border.all(color: outline)),
          child: Image.asset(
            iconAssetUrl,
            height: 72,
            width: 72,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
