import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/shared_widgets/avatar.dart';
import 'package:kudu/core/utils/price_formatter.dart';
import 'package:kudu/core/utils/textfield_input_formatters.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/auction.dart';
import '../../models/enums_and_extensions.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';

part 'widgets/image_view.dart';
part 'widgets/bid_information.dart';
part 'widgets/bid_price_input.dart';
part 'widgets/join_bid_button.dart';
part 'widgets/auction_information.dart';
part 'widgets/key_value_pair_viewer.dart';
part 'widgets/vendor_information.dart';

class BidDetailsScreen extends StatelessWidget {
  final Auction auction;
  const BidDetailsScreen(this.auction, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const AppBackButton(),
            titleSpacing: 0,
            title: Text(auction.name.substringOfMaxLength(21),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            centerTitle: false,
            forceMaterialTransparency: true,
          ),
          body: SafeArea(
            minimum: const EdgeInsets.only(top: 10, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _ImageView(
                      imageUrls: [auction.image, ...auction.additionalImages],
                      status: auction.status()),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: UiConstant.horizontalPadding),
                    child: Column(
                      children: [
                        _AuctionInformation(auction),
                        const SizedBox(height: 26),
                        _BidInformation(auction),
                        const SizedBox(height: 26),
                        _VendorInformation(auction.storeID),
                        const SizedBox(height: 26),
                        ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              minimumSize:
                                  WidgetStateProperty.resolveWith<Size>(
                                      (_) => const Size(double.infinity, 49)),
                              visualDensity:
                                  VisualDensity.adaptivePlatformDensity,
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (_) => const Color(0xFFFF0F00)),
                              shape: WidgetStateProperty.resolveWith<
                                      OutlinedBorder>(
                                  (_) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7))),
                            ),
                            child: const Text("Leave this Auction"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
