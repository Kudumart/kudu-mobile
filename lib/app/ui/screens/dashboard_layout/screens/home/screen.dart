import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/data/models/advert_banner.dart';

import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/constants.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/sample_data.dart';
import 'package:kudu/app/ui/shared_widgets/bookmark_button.dart';

import '../../../../../data/models/enums.dart';
import '../../../../../data/models/product.dart';

part 'widgets/app_bar.dart';
part 'widgets/search_bar.dart';
part 'widgets/banners.dart';
part 'widgets/categories.dart';
part 'widgets/categories_header.dart';
part 'widgets/services.dart';
part 'widgets/categories_by_usage.dart';
part 'widgets/product_card.dart';
part 'widgets/side_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                const _AppBar(
                    username: "Dwaelo", userAvatar: UiImage.userAvatar),
                const SizedBox(height: 8),
                const _Banners(),
                const SizedBox(height: 15),

                // divider
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: UiConstant.horizontalPadding),
                    color: UiColor.borderline,
                    height: 1),
                const SizedBox(height: 18),
                const _LowerContainer()
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
    final List<dynamic> trending = [...sampleProducts];
    trending.insert(2, sampleAdvertBanner);
    return Container(
      padding: const EdgeInsets.fromLTRB(
          UiConstant.horizontalPadding, 15, UiConstant.horizontalPadding, 10),
      decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const _Services(),
          const SizedBox(height: 19),

          // divider
          Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: UiConstant.horizontalPadding),
              color: UiColor.borderline,
              height: 1),
          const SizedBox(height: 25),
          const _CategoriesHeader(),
          const SizedBox(height: 13),
          const _Categories(),
          const SizedBox(height: 20),
          const _UsageCategories(),
          const SizedBox(height: 14),
          SizedBox(
            width: 40,
            child: LinearProgressIndicator(
                minHeight: 4,
                value: 0.6, // Set the progress value (between 0.0 and 1.0)
                backgroundColor: Colors.grey[300], // Background color
                borderRadius: BorderRadius.circular(8),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange)),
          ),
          const SizedBox(height: 30),

          ...trending.map<Widget>((item) {
            if (item is Product) {
              return _ProductCard(item);
            }
            if (item is AdvertBanner) {
              return Image.asset(
                item.url,
                height: 161,
              );
            }
            throw "Unknown trending item";
          })
        ],
      ),
    );
  }
}
