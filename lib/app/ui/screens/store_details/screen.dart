import 'package:date_format/date_format.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kudu/app/models/store.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';

part 'widgets/logo_container.dart';
part 'widgets/information_container.dart';

class StoreDetailsScreen extends StatefulWidget {
  final Store store;
  const StoreDetailsScreen(this.store, {super.key});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const AppBackButton(),
        titleSpacing: 0,
        title: const Text("Store Details",
            maxLines: 1, style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text("Edit",
                  style: TextStyle(fontSize: 14, color: AppUiColor.textBlue)))
        ],
      ),
      body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(22, 15, 22, 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _LogoContainer(),
                const SizedBox(height: 18),
                _InformationContainer(basic()),
                const SizedBox(height: 38),
                const Text("Location", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 18),
                _InformationContainer(location()),
              ],
            ),
          )),
    );
  }

  List<DataItem> basic() => [
        DataItem(
            value: widget.store.name,
            name: "Store Name",
            actionText: "Change",
            onClickActionText: () =>
                StoreProductsScreenRoute(widget.store).push(context)),
        DataItem(
          value: formatDate(widget.store.created, [dd, " ", MM, ", ", yyyy]),
          name: "Date Created",
        ),
        DataItem(
            value: widget.store.totalActiveProducts.toStringAsFixed(0),
            name: "Active Products",
            actionText: "Manage",
            onClickActionText: () =>
                StoreProductsScreenRoute(widget.store).push(context)),
      ];

  List<DataItem> location() => [
        DataItem(
          value: widget.store.country,
          name: "Country",
        ),
        DataItem(
            value: widget.store.state,
            name: "State",
            actionText: "Change",
            onClickActionText: () {}),
        DataItem(
            value: widget.store.city,
            name: "City",
            actionText: "Change",
            onClickActionText: () {}),
        if (widget.store.nearestLandMark != null)
          DataItem(
              value: widget.store.nearestLandMark!, name: "Nearest Landmark", actionText: "Change", onClickActionText: (){})
      ];
}
