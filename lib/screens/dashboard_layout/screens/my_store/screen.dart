import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/state_utils.dart';
import 'package:dart_countries/dart_countries.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/shared_widgets/app_image.dart';
import 'package:kudu/core/utils/input_validators.dart';
import 'package:kudu/models/currency_model.dart';
import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/models/home/delivery_options_model.dart';
import 'package:kudu/providers/home_provider.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:kudu/screens/authentication/shared_widgets/custom_filled_text_form_field.dart';
import 'package:kudu/screens/dashboard_layout/screens/my_store/widgets/currency.dart';
import 'package:provider/provider.dart';
import 'package:kudu/core/shared_widgets/app_button.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';

import '../../../../models/store.dart';
import '../../../../core/colors.dart';
import '../../../../core/constants.dart';
import '../../../vendor_analytics/screen.dart';

part 'widgets/create_store_button.dart';
part 'widgets/create_store_forms.dart';
part 'widgets/custom_outlined_text_field.dart';
part 'widgets/custom_outlined_dropdown.dart';
part 'widgets/empty_store.dart';
part 'widgets/store_info_card.dart';

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({super.key});

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  final List<Store> _stores = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).getStores(
        context: context,
        isLoading: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUiColor.ghostWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("My Store", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.black),
            tooltip: "Analytics",
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VendorAnalyticsScreen()));
            },
          ),
          const _AddNewStoreButton(),
        ],
      ),
      body: Consumer<HomeViewModel>(builder: (context, model, child) {
        return RefreshIndicator(
          onRefresh: () => model.getStores(context: context, isLoading: false),
          child: SafeArea(
            minimum: const EdgeInsets.fromLTRB(
              UiConstant.horizontalPadding,
              30,
              UiConstant.horizontalPadding,
              10,
            ),
            child: model.getStoreModel.isEmpty
                ? const _EmptyStoreView()
                : SingleChildScrollView(
                    child: Column(spacing: 10,
                      children: [
                        if (_storesNeedingDeliveryUpdate(model.getStoreModel).isNotEmpty)
                          _DeliveryZoneBanner(
                            store: _storesNeedingDeliveryUpdate(model.getStoreModel).first,
                            count: _storesNeedingDeliveryUpdate(model.getStoreModel).length,
                          ),
                        ...model.getStoreModel.map((store) => _StoreInfoCard(store)),
                      ],
                    ),
                  ),
          ),
        );
      }),
    );
  }

  /// Stores whose delivery options still use the old free-text setup (no
  /// coverage scope / country), so they need to be re-picked.
  List<GetStoreModel> _storesNeedingDeliveryUpdate(List<GetStoreModel> stores) {
    return stores.where((store) {
      final options = store.deliveryOptions ?? [];
      return options.isEmpty ||
          options.any((o) =>
              (o.scope ?? '').isEmpty ||
              ((o.countryCode ?? '').isEmpty && (o.country ?? '').isEmpty));
    }).toList();
  }

  _addNewStore(Store store) {
    setState(() => _stores.add(store));
  }
}


class _DeliveryZoneBanner extends StatelessWidget {
  final GetStoreModel store;
  final int count;
  const _DeliveryZoneBanner({required this.store, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        border: Border.all(color: const Color(0xFFFCD34D)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.pin_drop_outlined, color: Color(0xFF92400E), size: 20),
              SizedBox(width: 8),
              Text("Update your delivery zones",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF92400E))),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            count > 1
                ? "We now match deliveries by country, state and city. $count of your stores need their delivery coverage re-selected so customers can still check out."
                : "We now match deliveries by country, state and city. Re-select where your store delivers so customers can still check out.",
            style: const TextStyle(fontSize: 12, color: Color(0xFF92400E)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
              ),
              onPressed: () => StoreDetailsScreenRoute(store).push(context),
              child: Text(count > 1 ? "Review stores" : "Update delivery zones"),
            ),
          ),
        ],
      ),
    );
  }
}
