import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/models/enums.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/sample_data.dart';
import 'package:kudu/app/ui/shared_widgets/divider.dart';

import '../../../models/product.dart';
import '../../constants.dart';

part 'widgets/drawer.dart';
part 'widgets/condition_products.dart';
part 'widgets/product_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.only(left: 12.0, top: 10),
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          centerTitle: false,
        ),
        body: const SafeArea(
            child: Scaffold(
          backgroundColor: AppUiColor.grey50,
          drawer: _Drawer(),
          drawerScrimColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 14,
                UiConstant.horizontalPadding, 10),
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
        )));
  }
}
