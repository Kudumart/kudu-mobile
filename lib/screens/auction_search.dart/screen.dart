import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/utils/price_formatter.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/auction.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';

part 'widgets/auction_info_card/auction_info_card.dart';
part 'widgets/auction_info_card/widgets/vendor_name.dart';
part 'widgets/auction_info_card/widgets/location.dart';
part 'widgets/auction_info_card/widgets/specs_and_bid_price.dart';

part 'widgets/black_container.dart';
part 'widgets/search_bar.dart';
part 'widgets/filter_button.dart';
part 'widgets/product_conditions.dart';

class AuctionSearchScreen extends StatelessWidget {
  const AuctionSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("All Auctions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          forceMaterialTransparency: true,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.only(bottom: 10),
            child: SingleChildScrollView(
              child: Column(children: [
                const _BlackContainer(),
                const SizedBox(height: 26),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UiConstant.horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ProductConditions(),
                      _FilterButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Featured Items",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                const SizedBox(height: 15),
                ...List.filled(12, sampleAuction)
                    .map((auction) => _AuctionInfoCard(auction))
              ]),
            )));
  }
}
