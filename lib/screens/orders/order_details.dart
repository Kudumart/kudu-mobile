import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/app_image.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:kudu/models/home/cart_list_model.dart';
import 'package:provider/provider.dart';

import '../../models/enums_and_extensions.dart';
import '../../models/home/customer_order_details.dart';
import '../../models/home/order_details.dart';
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
import '../../providers/profile_provider.dart';
import '../product_details/screen.dart';
import '../product_search/screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderId;
  const OrderDetailsScreen({this.orderId, super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderDetails? item;
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
    if((widget.orderId ?? "").trim().isNotEmpty){
      var provider = Provider.of<HomeViewModel>(context, listen: false);
      item = await provider.fetchOrderDetails(context: context,showLoader: false,orderId: widget.orderId ?? "");
    }
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> cancelOrder() async {
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    var newStatus = "cancelled";
    await Future.forEach((item?.data ?? <OrderDetail>[]), (e) async {
      var response = await provider.updateOrderStatus(context: context, status: newStatus, orderId: e.id ?? "");
      if(response){
        e.status = newStatus;
      }
    });
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }
  Future<void> moveOrderToNextStatus() async {
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    var currentStatus = item?.data?.firstOrNull?.status?.toLowerCase();
    var newStatus = "";
    if(currentStatus == "pending") {
      newStatus = "processing";
    }else if(currentStatus == "processing") {
      newStatus = "shipped";
    }else if(currentStatus == "shipped") {
      newStatus = "delivered";
    }
    await Future.forEach((item?.data ?? <OrderDetail>[]), (e) async {
      var response = await provider.updateOrderStatus(context: context, status: newStatus, orderId: e.id ?? "");
      if(response){
        e.status = newStatus;
      }
    });
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  bool isDelivered(){
    var itemToReturn = false;
    for (var element in (item?.data ?? [])) {
      if(element.status?.toLowerCase() == "delivered"){
        itemToReturn = true;
      }else{
        itemToReturn = false;
        break;
      }
    }
    return itemToReturn;
  }

  bool isCancelled(){
    var itemToReturn = false;
    for (var element in (item?.data ?? [])) {
      if(element.status?.toLowerCase() == "cancelled"){
        itemToReturn = true;
      }else{
        itemToReturn = false;
        break;
      }
    }
    return itemToReturn;
  }

  bool isProcessing(){
    var itemToReturn = false;
    for (var element in (item?.data ?? [])) {
      if(element.status?.toLowerCase() == "processing"){
        itemToReturn = true;
      }else{
        itemToReturn = false;
        break;
      }
    }
    return itemToReturn;
  }

  bool isPending(){
    var itemToReturn = false;
    for (var element in (item?.data ?? [])) {
      if(element.status?.toLowerCase() == "pending"){
        itemToReturn = true;
      }else{
        itemToReturn = false;
        break;
      }
    }
    return itemToReturn;
  }

  bool isShipped(){
    var itemToReturn = false;
    for (var element in (item?.data ?? [])) {
      if(element.status?.toLowerCase() == "shipped"){
        itemToReturn = true;
      }else{
        itemToReturn = false;
        break;
      }
    }
    return itemToReturn;
  }

  bool isPendingLineActive(){
    return isPending() || isProcessing() || isShipped() || isDelivered();
  }

  bool isProcessingLineActive(){
    return isProcessing() || isShipped() || isDelivered();
  }

  bool isShippedLineActive(){
    return isShipped() || isDelivered();
  }

  bool isDeliveredLineActive(){
    return isDelivered();
  }

  num totalPrice(){
    num total = 0;
    if(item?.data != null){
      for(var i = 0; i < (item?.data?.length ?? 0); i++){
        total += num.tryParse(item?.data?[i].price?.toString() ?? "") ?? 0;
      }
    }
    return total;
  }

  String get currency{
    return item?.data?.firstOrNull?.product?.store?.currency?.symbol ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    var provider = Provider.of<HomeViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        titleSpacing: 0,
        leading: AppBackButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.grey.withAlpha(30),
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 0, UiConstant.horizontalPadding, 10),
          child: Builder(
            builder: (context) {
              if((item?.data ?? []).isEmpty && !loading){
                return const Center(child: Text("Order Unavailable"));
              }
              if(loading){
                return const Center(child: CircularProgressIndicator());
              }

              var items = item?.data ?? <OrderDetail>[];
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.height,
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: context.height * 0.5,
                      ),
                      width: double.infinity,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            items.length == 1 ? "1 Items" : "${items.length} Items",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppUiColor.iconBlack,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: AppUiColor.primary,
                                size: 18,
                              ),
                              1.width,
                              Text(
                                "Placed On : ${formatDate((DateTime.tryParse(item?.data?.firstOrNull?.createdAt ?? "")?.toLocal() ?? DateTime.now()), [dd, '/', mm, '/', yyyy])}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppUiColor.iconBlack,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Total Price: $currency${totalPrice()}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: "Roboto",
                            ),
                          ),
                          const Divider(),
                          const Text(
                            "Items In This Order:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Flexible(
                            child: ListView.builder(
                              itemCount: items.length,
                              shrinkWrap: true,
                              itemBuilder: (_,index){
                                var i = items[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8,
                                    left: 1,
                                    top: 1
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppImage(
                                        imgUrl: i.product?.imageUrl ?? i.product?.additionalImages?.firstOrNull ?? "",
                                        fit: BoxFit.cover,
                                        borderColor: Colors.grey,
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              i.product?.name ?? "",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            5.height,
                                            Text(
                                              "Qty : ${i.quantity}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppUiColor.iconBlack,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            5.height,
                                            Text(
                                              "Price : $currency${i.price}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppUiColor.iconBlack,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            5.height,
                                            Row(
                                              children: [
                                                const Text(
                                                  "Delivery Status:",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppUiColor.iconBlack,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                5.width,
                                                Text(
                                                  i.status?.capitalizeFirst ?? "Pending",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppUiColor.primary,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    15.height,
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: context.height * 0.5,
                      ),
                      width: double.infinity,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Track Order",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          15.height,
                          Padding(
                            padding: const EdgeInsets.only(right: 18,left: 18),
                            child: Row(
                              children: [
                                DotIndicator(isActive: isPendingLineActive()),
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: isProcessingLineActive() ? AppUiColor.primary : Colors.grey,
                                  ),
                                ),
                                DotIndicator(isActive: isProcessingLineActive()),
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: isShippedLineActive() ? AppUiColor.primary : Colors.grey,
                                  ),
                                ),
                                DotIndicator(isActive: isShippedLineActive()),
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: isDeliveredLineActive() ? AppUiColor.primary : Colors.grey,
                                  ),
                                ),
                                DotIndicator(isActive: isDeliveredLineActive()),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Pending",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: isPendingLineActive() ? AppUiColor.primary : Colors.grey,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Processing",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: isProcessingLineActive() ? AppUiColor.primary : Colors.grey,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Shipped",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: isShippedLineActive() ? AppUiColor.primary : Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Delivered",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: isDeliveredLineActive() ? AppUiColor.primary : Colors.grey,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          15.height,
                          if(!isDelivered() && !isCancelled())...[
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: AppIconButton(
                                      label: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      bgColor: Colors.red,
                                      borderColor: Colors.red,
                                      onPressed: () async {
                                        bool cancel = false;
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Cancel Order'),
                                            content: const Text(
                                              'Are you sure you want to cancel this order?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  cancel = true;
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if(cancel){
                                          await cancelOrder();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                if (provider.accountType == 'Vendor' && item?.data?.firstOrNull?.vendorId == provider.userData?.id)...[
                                  10.width,
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: AppIconButton(
                                        label: const Text(
                                          'Next',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        bgColor: Colors.black,
                                        borderColor: Colors.black,
                                        onPressed: () async {
                                          bool next = false;
                                          await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Move Order To Next Status'),
                                              content: const Text(
                                                'Are you sure you want to move this order to the next status?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    next = true;
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if(next){
                                            await moveOrderToNextStatus();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                          if(isCancelled())...[
                            const SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Order Cancelled",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    20.height,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? AppUiColor.primary : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
