import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
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

import 'package:kudu/core/shared_widgets/app_button.dart';
import '../../core/shared_widgets/app_image.dart';
import '../../core/shared_widgets/overlay/overlay.dart';
import '../../models/home/products_list_model.dart';
import '../../models/product.dart';
import '../../models/reviews/review_models.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../core/shared_widgets/product_card_view_2.dart';
import '../../providers/chat_view_model.dart';
import '../../providers/home_provider.dart';
import '../bookmarked_products/screen.dart';
import '../cart/cart.dart';
import '../cart/cart_main_screen.dart';

part 'widgets/contact_seller_buttons.dart';
part 'widgets/location_and_usage_status.dart';
part 'widgets/cart_button.dart';
part 'widgets/images_view.dart';
part 'widgets/rating.dart';
part 'widgets/reviews_section.dart';
part 'widgets/shipping_cost.dart';
part 'widgets/similar_products.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productID;
  const ProductDetailsScreen({required this.productID, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int cartCount = 0;
  ProductData? product;
  List<ProductData> vendorProducts = [];
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
    loadCartCount();
    final vId = product?.vendor?.id ?? product?.vendorId ?? "";
    if (vId.isNotEmpty) {
      final vProds = await Provider.of<HomeViewModel>(context, listen: false).fetchProductsByVendor(context: context, vendorId: vId);
      vendorProducts = vProds.where((p) => p.id != (product?.id ?? widget.productID)).toList();
    }
    if(mounted){
      setState(() {

      });
    }
  }

  Future<void> loadCartCount() async {
    cartCount = await Provider.of<HomeViewModel>(context, listen: false).getItemCountInCart(context: context);
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

  String formatDiscountPrice() {
    final format = NumberFormat.currency(locale: "en-US", symbol: product?.store?.currency?.symbol ?? "\$");
    return format.format(num.tryParse(product?.discountPrice ?? "") ?? 0);
  }

  bool hasDiscount(){
    if(((num.tryParse(product?.discountPrice ?? "") ?? 0) > 0)){
      return true;
    }
    return false;
  }

  String get description{
    var description = product?.description;
    var otherDetails = product?.specification;
    if((description ?? "").isEmpty && (otherDetails ?? "").isEmpty){
      return "Seller didn't provide any description of this product at this time. Kindly reach out to the seller to get more direct and up-to-date information about the product";
    }
    return "${description?.trim()}";
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
            onTap: () async {
              final link = "https://kudumart.com/product/${product?.id ?? widget.productID}";
              await Clipboard.setData(ClipboardData(text: link));
              if (context.mounted) {
                AppUiOverlay().showSuccessSnackbarMessage(context, message: "Product link copied to clipboard");
              }
            },
            child: const Icon(Icons.share_outlined, size: 22, color: Colors.black87),
          ),
          const SizedBox(width: 10),
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
          Badge(
            backgroundColor: AppUiColor.primary,
            label: Text(
              cartCount.toString(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            child: const _CartButton(),
          ),
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
                      trailingWidget: Container(
                        height: 30,
                        width: 83,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5), color: _backgroundVerifiedColor()),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              product?.isVerified == true ? "Verified" : "Not Verified",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _textVerifiedColor()),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // product title
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Text(
                        product?.name ?? "",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // price
                    Text(
                      formatPrice(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: hasDiscount() ? Colors.black : AppUiColor.primary,
                        fontFamily: "Roboto",
                        decoration: hasDiscount() ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if(hasDiscount())...[
                      Text(
                        formatDiscountPrice(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppUiColor.primary,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ],
                    Text(
                      "Quantity Available: ${product?.quantity ?? 0}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: "Roboto",
                      ),
                    ),
                    if(product?.vendor != null)...[
                      const SizedBox(height: 13),
                      _ContactSellerButtons(sellerPhoneNumber: product?.vendor?.phoneNumber ?? "",product: product),
                    ],
                    const SizedBox(height: 20),
                    if(product?.isVerified ?? false)...[
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: AppButton(
                          text: isInBookMarks ? 'Added To Your Bookmarks' : 'Add To Bookmarks',
                          icon: SvgPicture.asset(AppUiIcon.bookmarkFilled,
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          onPressed: isInBookMarks ? null : () async {
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
                    ],
                    _Rating(product?.averageRating ?? 0, totalReviews: product?.totalReviews ?? 0),
                    /*const SizedBox(height: 13),
                    const _ShippingCost(),*/
                    const SizedBox(height: 18),
                    if (product?.warranty != null && (product?.warranty ?? "").isNotEmpty)
                      Card(
                        elevation: 0,
                        color: const Color(0xFFF9F9F9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Warranty", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 5),
                              Text(product?.warranty ?? "", style: const TextStyle(fontSize: 14, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ),
                    if (product?.returnPolicy != null && (product?.returnPolicy ?? "").isNotEmpty)
                      Card(
                        elevation: 0,
                        color: const Color(0xFFF9F9F9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Return Policy", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 5),
                              Text(product?.returnPolicy ?? "", style: const TextStyle(fontSize: 14, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ),
                    Card(
                      elevation: 0,
                      color: const Color(0xFFF9F9F9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DescriptionWidget(
                          key: Key(product?.id ?? ""),
                          description: description,
                          specs: product?.specification,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: const Color(0xFFF9F9F9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _ReviewsSection(reviews: product?.reviews ?? []),
                      ),
                    ),
                  ],
                ),
              ),
              _VendorProductsSection(
                productID: product?.id ?? widget.productID,
                vendorProducts: vendorProducts,
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
              if(product?.isVerified ?? false)...[
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
                        child: AppButton(
                          text: 'Add To Cart',
                          icon: SvgPicture.asset(AppUiIcon.cart,
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          onPressed: quantityToAdd > 0 ? () async {
                            if (homeViewModel.isLoggedIn) {
                              await addToCart();
                              await loadCartCount();
                            } else {
                              const SignUpOptionsScreenRoute(UserType.customer).push(context);
                            }
                          } : null,
                        ),
                      ),
                    ),
                  ],
                ),
                10.height,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _backgroundVerifiedColor() {
    if(product?.isVerified ?? false) {
      return const Color(0xFF34A853);
    }else{
      return const Color.fromARGB(255, 238, 190, 15);
    }
  }

  Color _textVerifiedColor() {
    if(product?.isVerified ?? false) {
      return Colors.white;
    }else{
      return Colors.black;
    }
  }
}

class DescriptionWidget extends StatefulWidget {
  const DescriptionWidget({
    super.key,
    required this.description,
    this.specs,
  });
  final String description;
  final String? specs;

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  String textToShow = "";
  String totalText = "";
  bool showMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      parseHtml();
    });
  }

  void parseHtml(){
    try{
      var document = parse(widget.description);
      var description = parse(document.body!.text).documentElement?.text ?? "";
      totalText = description;
      if(totalText.length > 200) {
        textToShow = totalText.substring(0, 200);
      }else{
        textToShow = totalText;
      }
    }catch(_){
      totalText = widget.description;
      if(totalText.length > 200) {
        textToShow = totalText.substring(0, 200);
      }else{
        textToShow = totalText;
      }
    }
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppUiColor.iconBlack,
          ),
        ),
        RichText(
          text: TextSpan(
            text: showMore ? totalText : textToShow,
            style: const TextStyle(
              fontSize: 16,
              color: AppUiColor.iconBlack,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        if(widget.specs != null && widget.specs!.isNotEmpty && showMore)...[
          const Text(
            "Specifications",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppUiColor.iconBlack,
            ),
          ),
          const SizedBox(height: 5),
          HtmlWidget(
            widget.specs ?? "",
            textStyle: const TextStyle(
              fontSize: 14,
              color: AppUiColor.iconBlack,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
        if(totalText.length > 200 || (widget.specs ?? "").isNotEmpty)...[
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              setState(() {
                showMore = !showMore;
              });
            },
            child: Text(
              showMore ? "Show Less" : "Show More",
              style: const TextStyle(
                fontSize: 14,
                color: AppUiColor.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class AppIconButton extends StatefulWidget {
  const AppIconButton({
    super.key,
    this.onPressed,
    this.icon,
    this.label,
    this.bgColor,
    this.borderColor,
    this.enabled = true,
  });
  final Function()? onPressed;
  final Widget? icon;
  final Widget? label;
  final Color? bgColor;
  final Color? borderColor;
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
        side: BorderSide(color: widget.enabled ? (widget.borderColor ?? AppUiColor.primary) : Colors.grey),
        backgroundColor: widget.enabled ? (widget.bgColor ?? AppUiColor.primary) : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
