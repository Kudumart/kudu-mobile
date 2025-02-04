import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/models/store.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:kudu/screens/dashboard_layout/screens/my_store/screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/get_product_model.dart';
part 'widgets/logo_container.dart';
part 'widgets/information_container.dart';

class StoreDetailsScreen extends StatefulWidget {
  final GetStoreModel store;
  const StoreDetailsScreen(this.store, {super.key});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  int numberOfProducts = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStoreCount();
    });
  }

  void getStoreCount(){
    var provider = Provider.of<StoreViewModel>(context, listen: false);
    provider.getVendorsProducts(context: context).then((_){
      var products = provider.getproductsModel;
      numberOfProducts = products.where((element) => element.storeId == widget.store.id).length;
      if(mounted){
        setState(() {

        });
      }
    });
  }

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
            onPressed: () {
              _openBottomSheet(context, widget.store);
            },
            child: const Text(
              "Edit",
              style: TextStyle(fontSize: 14, color: AppUiColor.textBlue),
            ),
          )
        ],
      ),
      body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(22, 15, 22, 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LogoContainer(
                  store: widget.store,
                ),
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
          value: widget.store.name!,
          name: "Store Name",
          actionText: "",
          onClickActionText: () {
            return StoreProductsScreenRoute(widget.store).push(
              context,
            );
          },
        ),
        DataItem(
          value: formatDate(widget.store.createdAt!, [dd, " ", MM, ", ", yyyy]),
          name: "Date Created",
        ),
        DataItem(
          value: numberOfProducts.toString(),
          name: "Active Products",
          actionText: "Manage",
          onClickActionText: () async {
            await StoreProductsScreenRoute(widget.store).push(context);
            getStoreCount();
          },
        ),
      ];

  List<DataItem> location() {
    final Map<String, dynamic> locationMap = json.decode(
        widget.store.location ??
            "{\"address\":\"\",\"city\":\"\",\"state\":\"\",\"country\":\"\"}");

    return [
      DataItem(
        value: locationMap['country'],
        name: "Country",
      ),
      DataItem(
        value: locationMap['state'],
        name: "State",
        actionText: "",
        onClickActionText: () {},
      ),
      DataItem(
        value: locationMap['city'],
        name: "City",
        actionText: "",
        onClickActionText: () {},
      ),
      // if (widget.store.nearestLandMark != null)
      //   DataItem(
      //       value: widget.store.nearestLandMark!,
      //       name: "Nearest Landmark",
      //       actionText: "Change",
      //       onClickActionText: () {})
    ];
  }
}

_openBottomSheet(BuildContext context, GetStoreModel store) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true, // To ensure content is visible with keyboard
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    builder: (context) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6, // Initial height (60% of screen)
          maxChildSize: 0.9, // Maximum height (90% of screen)
          minChildSize: 0.3, // Minimum height (30% of screen)
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: CreateStoreForms(
                store: store,
              ),
            );
          },
        ),
      );
    },
  );
}
