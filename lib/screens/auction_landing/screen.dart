import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/utils/price_formatter.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/auction.dart';
import '../../models/enums_and_extensions.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/sample_data.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../core/shared_widgets/bookmark_button.dart';
import '../../core/shared_widgets/dot_progress_indicator.dart';
import '../../core/shared_widgets/product_condition.dart';

part 'widgets/search_bar.dart';
part 'widgets/black_container.dart';
part 'widgets/auction_steps.dart';
part 'widgets/auction_step.dart';
part 'widgets/auction_by_categories.dart';
part 'widgets/auction_products_pagedview.dart';

part 'widgets/info_card/auction_card.dart';
part 'widgets/info_card/widgets/image_view.dart';
part 'widgets/info_card/widgets/vendor_name.dart';
part 'widgets/info_card/widgets/location.dart';

class AuctionLandingScreen extends StatelessWidget {
  const AuctionLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const AppBackButton(),
        titleSpacing: 0,
        title: const Text("Auction",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: false,
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
          minimum: const EdgeInsets.only(bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const _BlackContainer(),
                const _AuctionSteps(),
                const SizedBox(height: 32),
                const _AuctionByCategoriesHeader(),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: UiConstant.horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Hot 🔥",
                          style: TextStyle(fontSize: 16, fontFamily: "Roboto")),
                      GestureDetector(
                        onTap: () =>
                            const AuctionSearchScreenRoute().push(context),
                        child: const Text(
                          "See All Categories",
                          style: TextStyle(
                              fontSize: 15, color: AppUiColor.primary),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UiConstant.horizontalPadding),
                  child: _AuctionProductPagedView(),
                )
              ],
            ),
          )),
    );
  }
}
