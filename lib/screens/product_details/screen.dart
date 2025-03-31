import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/data/storage/shared_preferences.dart';
import 'package:kudu/models/chat/conversation_list.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/bookmark_button.dart';
import 'package:kudu/core/utils/helpers.dart';
import 'package:provider/provider.dart';

import '../../core/shared_widgets/app_image.dart';
import '../../core/shared_widgets/overlay/overlay.dart';
import '../../models/home/products_list_model.dart';
import '../../models/product.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../core/shared_widgets/product_card_view_2.dart';
import '../../providers/chat_view_model.dart';
import '../../providers/home_provider.dart';
import '../bookmarked_products/screen.dart';
import '../cart/cart.dart';

part 'widgets/contact_seller_buttons.dart';
part 'widgets/location_and_usage_status.dart';
part 'widgets/cart_button.dart';
part 'widgets/images_view.dart';
part 'widgets/rating.dart';
part 'widgets/shipping_cost.dart';
part 'widgets/similar_products.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productID;
  const ProductDetailsScreen({required this.productID, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductData? product;
  late HomeViewModel homeViewModel;

  @override
  initState() {
    super.initState();
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProduct();
    });
  }

  Future<void> getProduct() async {
    product = await Provider.of<HomeViewModel>(context, listen: false).fetchProduct(context: context, productId: widget.productID);
    if(mounted){
      setState(() {

      });
    }
  }

  List<String> get productImages{
    var listToReturn = <String>[];
    if(product != null && product?.imageUrl != null){
      listToReturn.add(product?.imageUrl ?? "");
    }
    if(product != null && product?.additionalImages != null){
     product?.additionalImages?.forEach((e){
        listToReturn.add(e.toString());
     });
    }
    listToReturn = listToReturn.toSet().toList();
    return listToReturn;
  }

  String formatPrice() {
    final format = NumberFormat.currency(locale: "en-US", symbol: product?.store?.currency?.symbol ?? "\$");
    return format.format(num.tryParse(product?.price ?? "") ?? 0);
  }

  String get description{
    var description = product?.description;
    var otherDetails = product?.specification;
    if((description ?? "").isEmpty && (otherDetails ?? "").isEmpty){
      return "Seller didn't provide any description of this product at this time. Kindly reach out to the seller to get more direct and up-to-date information about the product";
    }

    if(description?.trim() == otherDetails?.trim()){
      return description ?? "";
    }
    return "${description?.trim()}\n\n${otherDetails?.trim()}";
  }

  String get location{
    if(product?.store == null){
      return "Not Available";
    }
    if(product?.store?.location == null){
      return "Not Available";
    }
    try{
      var city = product?.store?.location?.city?.toString().trim() ?? "";
      var state = product?.store?.location?.state?.toString().trim() ?? "";
      var country = product?.store?.location?.country?.toString().trim() ?? "";

      var stringToReturn = city;
      if(city != state && state != ""){
        stringToReturn += ", $state";
      }
      if(city != country && country != ""){
        stringToReturn += ", $country";
      }
      return stringToReturn;
    }catch(_){
      return "Not Available";
    }
  }

  int quantityToAdd = 0;
  Future<void> addToCart() async{
    var response = await homeViewModel.addProductToCart(
      productId: product?.id ?? "",
      quantity: quantityToAdd,
      context: context,
    );
    if(response){
      quantityToAdd = 0;
      if(mounted){
        setState(() {

        });
      }
    }
  }
  Future<void> removeFromCart() async{}

  bool isInBookMarks = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const BookmarkedProductsScreen(),
                ),
              );
            },
              child: const BookmarkButton.filled(),
          ),
          const SizedBox(width: 10),
          const _CartButton(),
          const SizedBox(
            width: UiConstant.horizontalPadding,
          )
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(0, 8, 0, 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _ImagesPreview(productImages),
              const SizedBox(height: 11),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LocationAndProductConditionView(
                      location: location,
                      condition: product?.condition?.toProductCondition ?? ProductCondition.brandNew,
                    ),
                    const SizedBox(height: 20),

                    // product title
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.sizeOf(context).width * 0.2),
                      child: Text(
                        product?.name ?? "",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // price
                    Text(
                      formatPrice(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppUiColor.primary),
                    ),
                    if(product?.vendor != null)...[
                      const SizedBox(height: 13),
                      _ContactSellerButtons(sellerPhoneNumber: product?.vendor?.phoneNumber ?? "",product: product),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: AppIconButton(
                        label: Text(
                          isInBookMarks ? 'Added To Your Bookmarks' : 'Add To Bookmarks',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        enabled: !isInBookMarks,
                        icon: SvgPicture.asset(AppUiIcon.bookmarkFilled,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        onPressed: () async {
                          if (homeViewModel.isLoggedIn) {
                            if (isInBookMarks) {
                              await homeViewModel.removeProductFromBookmarks(context: context, productId: product?.id ?? "");
                            } else {
                              await homeViewModel.addProductToBookmarks(context: context, productId: product?.id ?? "");
                            }
                          } else {
                            const SignUpOptionsScreenRoute(UserType.customer).push(context);
                          }
                          if(mounted){
                            setState(() {
                              isInBookMarks = !isInBookMarks;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Todo: Add rating
                    /*const _Rating(4),*/
                    /*const SizedBox(height: 13),
                    const _ShippingCost(),*/
                    const SizedBox(height: 18),
                    Container(color: AppUiColor.borderline, height: 1),
                    const SizedBox(height: 18),
                    HtmlWidget(description),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              _SimilarProducts(
                productID: product?.id ?? widget.productID,
                similarProducts: product?.recommendedProducts ?? [],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 10,left: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (quantityToAdd > 0) {
                        setState(() {
                          quantityToAdd--;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: quantityToAdd > 0 ? AppUiColor.primary : Colors.grey,
                      ),
                      child: const Icon(
                        Icons.remove_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  10.width,
                  Text(
                    quantityToAdd.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.width,
                  InkWell(
                    onTap: () {
                      setState(() {
                        quantityToAdd++;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 50,
                      width: 50,
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
                  10.width,
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: AppIconButton(
                        label: const Text(
                          'Add To Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        enabled: quantityToAdd > 0,
                        icon: SvgPicture.asset(AppUiIcon.cart,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        onPressed: () async {
                          if (homeViewModel.isLoggedIn) {
                            await addToCart();
                          } else {
                            const SignUpOptionsScreenRoute(UserType.customer).push(context);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              10.height,
            ],
          ),
        ),
      ),
    );
  }
}

class AppIconButton extends StatefulWidget {
  const AppIconButton({
    super.key,
    this.onPressed,
    this.icon,
    this.label,
    this.enabled = true,
  });
  final Function()? onPressed;
  final Widget? icon;
  final Widget? label;
  final bool enabled;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: !widget.enabled ? null : () async {
        if(mounted){
          setState(() {
            isLoading = true;
          });
        }
        await widget.onPressed?.call();
        if(mounted){
          setState(() {
            isLoading = false;
          });
        }
      },
      icon: isLoading ? const SizedBox() : widget.icon ?? const SizedBox(),
      label: isLoading ? const SizedBox(height:25,width: 25,child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )) : (widget.label ?? const SizedBox()),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: widget.enabled ? AppUiColor.primary : Colors.grey),
        backgroundColor: widget.enabled ? AppUiColor.primary : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
