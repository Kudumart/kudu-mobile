import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/utils/input_validators.dart';

import '../../../../../models/store.dart';
import '../../../../colors.dart';
import '../../../../constants.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppUiColor.ghostWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("My Store",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          actions: [
            _AddNewStoreButton(
              onAddNewStore: _addNewStore,
            )
          ],
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 30,
                UiConstant.horizontalPadding, 10),
            child: _stores.isEmpty
                ? const _EmptyStoreView()
                : Column(
                    children:
                        _stores.map((store) => _StoreInfoCard(store)).toList(),
                  )));
  }

  _addNewStore(Store store) {
    setState(() => _stores.add(store));
  }
}
