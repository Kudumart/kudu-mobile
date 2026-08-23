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
import '../../models/home/order_list_data.dart';
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
import '../product_details/screen.dart';
import '../product_search/screen.dart';
import 'order_details.dart';
import '../../core/shared_widgets/app_button.dart';

class OrderScreen extends StatefulWidget {
  final SearchFilter? searchFilter;
  const OrderScreen({this.searchFilter, super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderListData? products;
  bool loading = false;
  late HomeViewModel provider;

  @override
  initState() {
    super.initState();
    provider = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
    });
  }

  Future<void> getProducts({String? searchTerm}) async {
    if(mounted){
      setState(() {
        loading = true;
      });
    }
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    products = await provider.fetchOrders(context: context,showLoader: false);
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  String get shippingAddress{
    var location = provider.userData?.location;
    var address = location?.address ?? "";
    var city = location?.city ?? "";
    var state = location?.state ?? "";
    var country = location?.country ?? "";
    var textToReturn = "";
    if(address.isNotEmpty){
      textToReturn += address;
    }
    if(city.isNotEmpty){
      textToReturn += textToReturn.isNotEmpty ? ", $city" : city;
    }
    if(state.isNotEmpty){
      textToReturn += textToReturn.isNotEmpty ? ", $state" : state;
    }
    if(country.isNotEmpty){
      textToReturn += textToReturn.isNotEmpty ? ", $country" : country;
    }
    return textToReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 0, UiConstant.horizontalPadding, 10),
          child: Builder(
            builder: (context) {
              if((products?.data ?? []).isEmpty && !loading){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.cube_box, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 20),
                      const Text(
                        "No Orders Found",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          "You don't have any orders yet. Start shopping to see your orders here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: AppButton(
                          text: "Start Shopping",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              if(loading){
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: products?.data?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  var order = products?.data?[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(
                        builder: (context) => OrderDetailsScreen(
                          orderId: order?.id,
                        ),
                      ));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order ID : ${order?.id}", style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          const SizedBox(height: 5),
                          Text("Total Amount : ${order?.totalAmount}", style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          )),
                          const SizedBox(height: 5),
                          Text("Shipping Address : ${order?.shippingAddress}", style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          const SizedBox(height: 5),
                          Text("Created At : ${formatDate((DateTime.tryParse(order?.createdAt ?? "")?.toLocal() ?? DateTime.now()), [dd, '/', mm, '/', yyyy])}", style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          )),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          ),
      ),
    );
  }
}
