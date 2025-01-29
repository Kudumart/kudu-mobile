import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/bid.dart';
import '../../models/enums_and_extensions.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../core/utils/price_formatter.dart';

part 'widgets/black_container.dart';
part 'widgets/filter_button.dart';

part 'widgets/bid_card/card.dart';
part 'widgets/bid_card/widgets/location.dart';
part 'widgets/bid_card/widgets/more_info.dart';
part 'widgets/bid_card/widgets/vendor_name.dart';

class MonitorMyBidsScreen extends StatelessWidget {
  const MonitorMyBidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bids = List.filled(
        5,
        Bid(
            auction: sampleAuction,
            id: "1",
            price: 8500,
            created: DateTime.now()));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const AppBackButton(),
        titleSpacing: 0,
        title: const Text("Monitor your Bids",
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
              const SizedBox(height: 26),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: UiConstant.horizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Bids",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    _FilterButton(),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              ...bids.map(
                (bid) => _BidCard(bid),
              )
            ],
          ),
        ),
      ),
    );
  }
}
