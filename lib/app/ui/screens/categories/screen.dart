import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/models/enums.dart';
import 'package:kudu/app/models/search_filter.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/sample_data.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';
import 'package:kudu/app/ui/shared_widgets/divider.dart';

import '../../../models/product.dart';
import '../../constants.dart';

part 'widgets/drawer.dart';
part 'widgets/condition_products.dart';
part 'widgets/product_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late bool _isDrawerOpen;

  @override
  void initState() {
    super.initState();
    _isDrawerOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Trending",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          centerTitle: false,
          leading: const AppBackButton(),
          titleSpacing: 0,
          actions: [
            GestureDetector(
              onTap: _toggleDrawer,
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppUiColor.borderline,
                ),
                child: Icon(_isDrawerOpen ? Icons.close : Icons.menu,
                    color: AppUiColor.iconBlack, size: 20),
              ),
            )
          ],
        ),
        body: SafeArea(
            child: Scaffold(
          backgroundColor: AppUiColor.grey50,
          body: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(UiConstant.horizontalPadding,
                        0, UiConstant.horizontalPadding, 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _ConditionProducts(
                              condition: ProductCondition.brandNew,
                              products: sampleProducts),
                          SizedBox(height: 11),
                          _ConditionProducts(
                              condition: ProductCondition.refurbished,
                              products: sampleProducts),
                          SizedBox(height: 11),
                          _ConditionProducts(
                              condition: ProductCondition.used,
                              products: sampleProducts),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isDrawerOpen)
                  Positioned.fill(
                      child: GestureDetector(
                          onTap: _toggleDrawer,
                          child: const Material(color: Colors.black12))),
                if (_isDrawerOpen)
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: _Drawer(
                        closeDrawer: _toggleDrawer,
                      ))
              ],
            ),
          ),
        )));
  }

  _toggleDrawer() {
    setState(() => _isDrawerOpen = !_isDrawerOpen);
  }
}
