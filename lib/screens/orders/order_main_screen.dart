import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:kudu/models/home/cart_list_model.dart';
import 'package:provider/provider.dart';

import '../../models/enums_and_extensions.dart';
import '../../models/home/products_list_model.dart';
import '../../models/jobs/job_details_model.dart';
import '../../models/product.dart';
import '../../models/search_filter.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../providers/chat_view_model.dart';
import '../../providers/home_provider.dart';
import '../../providers/profile_provider.dart';
import '../product_details/screen.dart';
import '../product_search/screen.dart';
import 'customers_orders.dart';
import 'orders.dart';

class OrderMainScreen extends StatefulWidget {
  final SearchFilter? searchFilter;
  const OrderMainScreen({this.searchFilter, super.key});

  @override
  State<OrderMainScreen> createState() => _OrderMainScreenState();
}

class _OrderMainScreenState extends State<OrderMainScreen> with TickerProviderStateMixin{
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProfileViewModel>(context, listen: false);

    return PopScope(
      onPopInvokedWithResult: (c,result){
        Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Orders",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            centerTitle: false,
            titleSpacing: 0,
            leading: AppBackButton(
              onPressed: (){
                Navigator.of(context).pop();
                Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
              },
            ),
          ),
          body: Column(
            children: [
              if (provider.accountType == 'Vendor')...[
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppUiColor.primary,
                    tabs: const [
                      Tab(text: "Orders"),
                      Tab(text: "Customer's Orders"),
                    ],
                  ),
                ),
                15.height,
              ],
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    OrderScreen(searchFilter: widget.searchFilter),
                    CustomersOrdersScreen(searchFilter: widget.searchFilter),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
