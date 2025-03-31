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
import '../product_details/screen.dart';
import '../product_search/screen.dart';
import 'create_shipping_address.dart';

class CartScreen extends StatefulWidget {
  final SearchFilter? searchFilter;
  const CartScreen({this.searchFilter, super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartListModel? products;
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
    products = await provider.fetchCart(context: context);
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  double get totalPrice{
    return (products?.data ?? []).fold(0, (previousValue, element) => previousValue + (double.tryParse(element.product?.price ?? "") ?? 0) * (element.quantity?.toInt() ?? 0));
  }

  String get currency{
    return (products?.data ?? []).isNotEmpty ? products?.data?.first.product?.store?.currency?.symbol ?? "" : "";
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
    return PopScope(
      onPopInvokedWithResult: (c,result){
        Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Cart",
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
          body: SafeArea(
              minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 0, UiConstant.horizontalPadding, 10),
              child: Builder(
                builder: (context) {
                  if((products?.data ?? []).isEmpty && !loading){
                    return const Center(child: Text("No Products In Cart"));
                  }

                  return SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 19,
                      spacing: 5,
                      children: (products?.data ?? []).map((product) => CartItem(
                        key: ValueKey(product.id),
                        cartData: product,
                        onOneAdded: () async {
                          var provider = Provider.of<HomeViewModel>(context, listen: false);
                          await provider.updateProductInCart(context: context, cartId: product.id ?? "", quantity: (product.quantity?.toInt() ?? 0) + 1);
                          getProducts();
                        },
                        onOneRemoved: () async {
                          var provider = Provider.of<HomeViewModel>(context, listen: false);
                          await provider.updateProductInCart(context: context, cartId: product.id ?? "", quantity: (product.quantity?.toInt() ?? 0) - 1);
                          getProducts();
                        },
                        onRemoved: () async {
                          var provider = Provider.of<HomeViewModel>(context, listen: false);
                          await provider.removeProductFromCart(context: context, cartId: product.id ?? "");
                          getProducts();
                        },
                      )).toList(),
                    ),
                  );
                }
              ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 10,left: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cart Summary",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Text(
                        "Item Total(${(products?.data ?? []).length})",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "$currency${totalPrice.toCurrencyFormat}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text(
                        "Delivery Address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          await Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context) => const CreateShippingAddress()));
                          if(mounted){
                            setState(() {});
                          }
                        },
                        child: const Text(
                          "Change Location",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppUiColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  5.height,
                  Text(
                    shippingAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(),
                  SizedBox(
                    height: 50,
                    child: AppIconButton(
                      label: Text(
                        'Checkout - $currency${totalPrice.toCurrencyFormat}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () async {
                        var ref = "";
                        var response = await provider.initiatePayment(
                          context: context,
                          amount: totalPrice,
                          onPaymentCompleted: (response){
                            ref = response.reference ?? "";
                          }
                        );
                        ref = response?.reference ?? "";
                        if(ref.trim().isNotEmpty){
                          await provider.confirmProductCheckout(context: context, address: shippingAddress, reference: ref);
                          await getProducts();
                        }
                      },
                    ),
                  ),
                  10.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.cartData, this.onRemoved, this.onOneAdded, this.onOneRemoved,
  });
  final CartData cartData;
  final Function()? onRemoved;
  final Function()? onOneAdded;
  final Function()? onOneRemoved;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      quantity = widget.cartData.quantity?.toInt() ?? 1;
      if(mounted){
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProductCardView1(
          widget.cartData.product!,
          bottomWidget: Row(
            children: [
              10.width,
              InkWell(
                onTap: () {
                  if (quantity > 0) {
                    setState(() {
                      quantity--;
                    });
                    if(quantity == 0){
                      widget.onRemoved?.call();
                    }else{
                      widget.onOneRemoved?.call();
                    }
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: quantity > 0 ? AppUiColor.primary : Colors.grey,
                  ),
                  child: const Icon(
                    Icons.remove_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              10.width,
              Text(
                quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              10.width,
              InkWell(
                onTap: () {
                  setState(() {
                    quantity++;
                  });
                  widget.onOneAdded?.call();
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppUiColor.primary,
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: InkWell(
            onTap: () {
              widget.onRemoved?.call();
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: AppUiColor.primary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
