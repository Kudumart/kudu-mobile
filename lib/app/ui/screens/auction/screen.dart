import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/enums.dart';
import '../../../models/product.dart';
import '../../colors.dart';
import '../../constants.dart';
import '../../images.dart';
import '../../routes/routes.dart';
import '../../sample_data.dart';
import '../../shared_widgets/back_button.dart';
import '../../shared_widgets/bookmark_button.dart';
import '../../shared_widgets/dot_progress_indicator.dart';
import '../../shared_widgets/product_condition.dart';

part 'widgets/search_bar.dart';
part 'widgets/black_container.dart';
part 'widgets/auction_steps.dart';
part 'widgets/auction_step.dart';
part 'widgets/auction_by_categories.dart';
part 'widgets/auction_products_pagedview.dart';

part 'widgets/product_card/product_card.dart';
part 'widgets/product_card/sub_widgets/add_button.dart';
part 'widgets/product_card/sub_widgets/image_view.dart';
part 'widgets/product_card/sub_widgets/location.dart';
part 'widgets/product_card/sub_widgets/price_view.dart';

class AuctionScreen extends StatelessWidget {
  const AuctionScreen({super.key});

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
      body: const SafeArea(
          minimum: EdgeInsets.only(bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _BlackContainer(),
                _AuctionSteps(),
                SizedBox(height: 32),
                _AuctionByCategoriesHeader(),
                SizedBox(height: 28),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UiConstant.horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Hot 🔥",
                          style: TextStyle(fontSize: 16, fontFamily: "Roboto")),
                      Text("See All Categories",
                          style: TextStyle(
                              fontSize: 15, color: AppUiColor.primary))
                    ],
                  ),
                ),
                SizedBox(height: 9),
                Padding(
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
