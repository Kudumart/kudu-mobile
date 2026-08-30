import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/core/shared_widgets/app_image.dart';
import 'package:kudu/core/shared_widgets/avatar.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/models/search_filter.dart';

import 'package:kudu/core/colors.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/core/utils/price_formatter.dart';
import 'package:kudu/core/shared_widgets/country_select_dropdown.dart';
import 'package:kudu/services/country_service.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/dot_progress_indicator.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:kudu/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/locator.dart';
import '../../../../core/shared_widgets/overlay/overlay.dart';
import '../../../../data/storage/shared_preferences.dart';
import '../../../../models/advert/advert_model.dart';
import '../../../../models/home/categories_model.dart';
import '../../../../models/home/products_list_model.dart';
import '../../../../models/product.dart';
import '../../../../core/shared_widgets/divider.dart';
import '../../../../providers/auth_viewmodel.dart';
import '../../../adverts/advert_screen.dart';
import '../../../jobs/jobs_screen.dart';
import '../../../services_marketplace/screen.dart';

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
part 'widgets/home_auction_products_view.dart';
part 'widgets/faq_and_policies_banners.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).getStores(
        context: context,
        isLoading: false,
      );
      // AuthViewmodel auth = locator<AuthViewmodel>();
      // bool isLoggedIn = StorageService().getBool('isLoggedIn') ?? false;
      // if(isLoggedIn){
      //   auth.fetchUserProfile(context: context);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Consumer<HomeViewModel>(builder: (context, model, child) {
        model.setup();
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            drawer: const _SideDrawer(),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    _AppBar(
                      provider: model,
                    ),
                    const SizedBox(height: 8),
                    const _Banners(),
                    const SizedBox(height: 13),
                    const _SearchBar(),
                    const SizedBox(height: 15),
                    _LowerContainer(
                      provider: model,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _LowerContainer extends StatelessWidget {
  final HomeViewModel provider;
  const _LowerContainer({required this.provider});

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
          const Text(
            "Popular",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 13),
          const _FoldableProductCategories(),
          const SizedBox(height: 20),
          // const _ProductConditionsHeader(),
          // const SizedBox(height: 19),
          const _TrendingHeader(),
          const _TrendingProductPagedView(),
          const SizedBox(height: 16),

          const CustomDivider(),
          const SizedBox(height: 20),
          const _AuctionHeader(),
          const SizedBox(height: 12),
          const _HomeAuctionProductsView(),
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
