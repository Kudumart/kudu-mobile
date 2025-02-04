import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:kudu/providers/home_provider.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:kudu/screens/authentication/shared_widgets/custom_filled_text_form_field.dart';
import 'package:kudu/screens/dashboard_layout/screens/my_store/widgets/currency.dart';
import 'package:provider/provider.dart';

import '../../../../models/store.dart';
import '../../../../core/colors.dart';
import '../../../../core/constants.dart';

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
        title: const Text("My Store",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: false,
        actions: const [
          _AddNewStoreButton(),
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
                : Column(spacing: 10,
                    children: model.getStoreModel.map((store) => _StoreInfoCard(store)).toList(),
                  ),
          ),
        );
      }),
    );
  }

  _addNewStore(Store store) {
    setState(() => _stores.add(store));
  }
}
