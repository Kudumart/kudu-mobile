import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/data/storage/shared_preferences.dart';
import 'package:kudu/app/models/search_filter.dart';

import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/constants.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/sample_data.dart';
import 'package:kudu/app/ui/shared_widgets/dot_progress_indicator.dart';
import 'package:kudu/app/ui/shared_widgets/overlay/overlay.dart';
import 'package:kudu/app/ui/shared_widgets/product_card_view_1/product_card_view_1.dart';

import '../../../../../models/product.dart';
import '../../../../shared_widgets/divider.dart';

part 'widgets/app_bar.dart';
part 'widgets/search_bar.dart';
part 'widgets/banners.dart';
part 'widgets/foldable_categories.dart';
part 'widgets/sections_headers.dart';
part 'widgets/services.dart';
part 'widgets/categories_by_conditions.dart';
part 'widgets/product_card.dart';
part 'widgets/side_drawer.dart';
part 'widgets/trending_product_paged_view.dart';
part 'widgets/quick_shop_products_view.dart';
part 'widgets/faq_and_policies_banners.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: const Scaffold(
        drawer: _SideDrawer(),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 12),
                _AppBar(username: "Guest", userAvatar: AppUiImage.userAvatar),
                SizedBox(height: 8),
                _Banners(),
                SizedBox(height: 13),
                _SearchBar(),
                SizedBox(height: 15),
                _LowerContainer()
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
          UiConstant.horizontalPadding, 15, UiConstant.horizontalPadding, 10),
      decoration: BoxDecoration(
          color: AppUiColor.ghostWhite,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Services(),
          const SizedBox(height: 25),

          // divider
          const CustomDivider(),
          const SizedBox(height: 25),
          const Text("Popular",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          const SizedBox(height: 13),
          const _FoldableProductCategories(),
          const SizedBox(height: 20),
          const _ProductConditionsHeader(),
          const SizedBox(height: 19),
          const _TrendingHeader(),
          const _TrendingProductPagedView(),
          const SizedBox(height: 16),

          const CustomDivider(),
          const SizedBox(height: 16),
          Image.asset(sampleAdvertBanner.url),
          const SizedBox(height: 16),

          const CustomDivider(),
          const SizedBox(height: 20),
          const _QuickShopHeader(),
          const SizedBox(height: 12),
          const _QuickShopProductsView(),
          const SizedBox(height: 20),
          const Row(
            children: [
              Flexible(flex: 1, child: _FaqBanner()),
              SizedBox(width: 10),
              Flexible(flex: 1, child: _PoliciesBanner()),
            ],
          )
        ],
      ),
    );
  }
}
