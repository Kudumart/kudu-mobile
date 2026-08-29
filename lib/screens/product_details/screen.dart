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
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void didUpdateWidget(covariant ProductDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productID != widget.productID) {
      getProduct();
    }
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
    final symbol = product?.store?.currency?.symbol ?? homeViewModel.currencySymbol;
    final format = NumberFormat.currency(locale: "en-US", symbol: symbol);
    return format.format(num.tryParse(product?.price ?? "") ?? 0);
  }

  String formatDiscountPrice() {
    final symbol = product?.store?.currency?.symbol ?? homeViewModel.currencySymbol;
    final format = NumberFormat.currency(locale: "en-US", symbol: symbol);
    return format.format(num.tryParse(product?.discountPrice ?? "") ?? 0);
  }

  bool hasDiscount(){
    if(((num.tryParse(product?.discountPrice ?? "") ?? 0) > 0)){
      return true;
    }
    return false;
  }

  bool get isVehicleOrProperty {
    final subCatName = product?.subCategory?.name?.toLowerCase() ?? "";
    final name = product?.name?.toLowerCase() ?? "";
    if (subCatName.contains("vehicle") || subCatName.contains("car") || subCatName.contains("auto") || subCatName.contains("truck")) return true;
    if (subCatName.contains("property") || subCatName.contains("house") || subCatName.contains("real estate") || subCatName.contains("land") || subCatName.contains("apartment") || subCatName.contains("building")) return true;
    if (name.contains("toyota") || name.contains("mercedes") || name.contains("honda") || name.contains("hyundai") || name.contains("duplex") || name.contains("mansion") || name.contains("bedroom apartment")) return true;
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

  int quantityToAdd = 1;
  Future<void> addToCart() async{
    var response = await homeViewModel.addProductToCart(
      productId: product?.id ?? "",
      quantity: quantityToAdd > 0 ? quantityToAdd : 1,
      context: context,
    );
    if(response){
      if(mounted){
        setState(() {
          quantityToAdd = 1;
        });
      }
    }
  }

  Future<void> handleBuyNow() async {
    if (homeViewModel.isLoggedIn) {
      if (quantityToAdd == 0) quantityToAdd = 1;
      var response = await homeViewModel.addProductToCart(
        productId: product?.id ?? "",
        quantity: quantityToAdd,
        context: context,
      );
      if (response) {
        await loadCartCount();
        if (mounted) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => const CartMainScreen(),
            ),
          );
        }
      }
    } else {
      const SignUpOptionsScreenRoute(UserType.customer).push(context);
    }
  }

  void _openMakeOfferModal(BuildContext context) {
    final offerPriceController = TextEditingController();
    final offerMessageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Make an Offer",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Listed Price: ${formatPrice()}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: offerPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Your Offered Price (${homeViewModel.currencySymbol})",
                  prefixText: "${homeViewModel.currencySymbol} ",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: const Color(0xFFF9F9F9),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: offerMessageController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Message to seller (optional)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: const Color(0xFFF9F9F9),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: AppButton(
                  text: 'Submit Offer',
                  variant: AppButtonVariant.primary,
                  onPressed: () async {
                    final price = double.tryParse(offerPriceController.text.replaceAll(',', '').trim());
                    if (price == null || price <= 0) {
                      AppUiOverlay().showErrorSnackbarMessage(context, message: "Please enter a valid offer price");
                      return;
                    }
                    Navigator.pop(ctx);
                    if (homeViewModel.isLoggedIn) {
                      await homeViewModel.submitProductOffer(
                        context: context,
                        productId: product?.id ?? widget.productID,
                        offeredPrice: price,
                        message: offerMessageController.text.trim(),
                      );
                    } else {
                      const SignUpOptionsScreenRoute(UserType.customer).push(context);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openContactSellerModal(BuildContext context) {
    final phone = product?.vendor?.phoneNumber ?? "";
    final email = product?.vendor?.email ?? "";
    final vendorName = "${product?.vendor?.firstName ?? ''} ${product?.vendor?.lastName ?? ''}".trim();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Contact Seller",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              if (vendorName.isNotEmpty) ...[
                Text(
                  "Vendor: $vendorName",
                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
              ],
              if (phone.isNotEmpty) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppUiColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.phone_rounded, color: AppUiColor.primary, size: 22),
                  ),
                  title: const Text("Phone Call", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: Text(phone, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(ctx);
                    launchUrl(Uri.parse("tel:$phone"));
                  },
                ),
                const Divider(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF25D366), size: 22),
                  ),
                  title: const Text("WhatsApp", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: Text("Chat on WhatsApp ($phone)", style: const TextStyle(color: Colors.black87, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(ctx);
                    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
                    launchUrl(Uri.parse("https://wa.me/$cleanPhone"));
                  },
                ),
                const Divider(height: 12),
              ],
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.message_outlined, color: Colors.blue, size: 22),
                ),
                title: const Text("In-App Chat", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                subtitle: const Text("Send a direct message on Kudumart", style: TextStyle(color: Colors.black87, fontSize: 13)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                onTap: () {
                  Navigator.pop(ctx);
                  if (homeViewModel.isLoggedIn) {
                    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
                    if (chatViewModel.userDataService.userData?.id == product?.vendor?.id) {
                      AppUiOverlay().showErrorSnackbarMessage(context, message: "You can't message yourself");
                      return;
                    }
                    var conversationListData = ConversationListData(
                      receiverId: product?.vendor?.id,
                      productId: product?.id,
                      product: ChatProduct(
                        id: product?.id,
                        name: product?.name,
                      ),
                      receiverUser: ReceiverUser(
                        id: product?.vendor?.id,
                        firstName: product?.vendor?.firstName,
                        lastName: product?.vendor?.lastName,
                        email: product?.vendor?.email,
                        phoneNumber: product?.vendor?.phoneNumber,
                        photo: product?.vendor?.photo,
                      ),
                    );
                    ChatScreenRoute(conversationListData).push(context);
                  } else {
                    const SignUpOptionsScreenRoute(UserType.customer).push(context);
                  }
                },
              ),
              if (email.isNotEmpty) ...[
                const Divider(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.email_outlined, color: Colors.purple, size: 22),
                  ),
                  title: const Text("Email Seller", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: Text(email, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(ctx);
                    launchUrl(Uri.parse("mailto:$email"));
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
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
              final price = product?.price != null ? " (${formatPrice()})" : "";
              final shareText = "Check out ${product?.name ?? 'this product'}$price on Kudumart: $link";
              await Clipboard.setData(ClipboardData(text: shareText));
              if (context.mounted) {
                AppUiOverlay().showSuccessSnackbarMessage(context, message: "Product link & details copied to clipboard");
              }
            },
            child: const Icon(Icons.share_outlined, size: 22, color: Colors.black87),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              isInBookMarks ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isInBookMarks ? Colors.red : Colors.black87,
              size: 24,
            ),
            onPressed: () async {
              if (homeViewModel.isLoggedIn) {
                if (isInBookMarks) {
                  final ok = await homeViewModel.removeProductFromBookmarks(context: context, productId: product?.id ?? widget.productID);
                  if (ok && mounted) setState(() => isInBookMarks = false);
                } else {
                  final ok = await homeViewModel.addProductToBookmarks(context: context, productId: product?.id ?? widget.productID);
                  if (ok && mounted) setState(() => isInBookMarks = true);
                }
              } else {
                const SignUpOptionsScreenRoute(UserType.customer).push(context);
              }
            },
          ),
          const SizedBox(width: 4),
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

                    if (product?.subCategory?.name != null && product!.subCategory!.name!.isNotEmpty) ...[
                      Text(
                        product!.subCategory!.name!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppUiColor.primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],

                    // product title
                    Text(
                      product?.name ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // price & in stock badge row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          formatPrice(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                            fontFamily: "Roboto",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: !(product?.isSoldOut ?? false) ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: !(product?.isSoldOut ?? false) ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
                            ),
                          ),
                          child: Text(
                            !(product?.isSoldOut ?? false)
                                ? (product?.quantity != null ? "In Stock (${product?.quantity})" : "In Stock")
                                : "Sold Out",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: !(product?.isSoldOut ?? false) ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons (Matching Website)
                    if (isVehicleOrProperty || (product?.vendor?.isVerified != true && product?.admin != true)) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: AppButton(
                          text: 'Contact Seller / Display Contact',
                          variant: AppButtonVariant.primary,
                          icon: const Icon(Icons.phone_outlined, color: Colors.white, size: 18),
                          onPressed: () => _openContactSellerModal(context),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: AppButton(
                                text: 'Make an Offer',
                                variant: AppButtonVariant.outline,
                                icon: const Icon(Icons.local_offer_outlined, color: AppUiColor.primary, size: 16),
                                onPressed: () => _openMakeOfferModal(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: AppButton(
                                text: isInBookMarks ? 'Saved' : 'Favorites',
                                variant: AppButtonVariant.outline,
                                icon: Icon(
                                  isInBookMarks ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                                  color: isInBookMarks ? AppUiColor.primary : Colors.black87,
                                  size: 16,
                                ),
                                onPressed: () async {
                                  if (homeViewModel.isLoggedIn) {
                                    if (isInBookMarks) {
                                      await homeViewModel.removeProductFromBookmarks(context: context, productId: product?.id ?? widget.productID);
                                    } else {
                                      await homeViewModel.addProductToBookmarks(context: context, productId: product?.id ?? widget.productID);
                                    }
                                    if (mounted) setState(() => isInBookMarks = !isInBookMarks);
                                  } else {
                                    const SignUpOptionsScreenRoute(UserType.customer).push(context);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: AppButton(
                                text: 'Add to Cart',
                                variant: AppButtonVariant.outline,
                                icon: SvgPicture.asset(AppUiIcon.cart, height: 18, width: 18, colorFilter: const ColorFilter.mode(AppUiColor.primary, BlendMode.srcIn)),
                                onPressed: () async {
                                  if (homeViewModel.isLoggedIn) {
                                    await addToCart();
                                    await loadCartCount();
                                  } else {
                                    const SignUpOptionsScreenRoute(UserType.customer).push(context);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: AppButton(
                                text: 'Buy Now',
                                variant: AppButtonVariant.primary,
                                icon: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
                                onPressed: handleBuyNow,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: AppButton(
                                text: 'Make an Offer',
                                variant: AppButtonVariant.outline,
                                icon: const Icon(Icons.local_offer_outlined, color: AppUiColor.primary, size: 16),
                                onPressed: () => _openMakeOfferModal(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: AppButton(
                                text: isInBookMarks ? 'Saved' : 'Favorites',
                                variant: AppButtonVariant.outline,
                                icon: Icon(
                                  isInBookMarks ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                                  color: isInBookMarks ? AppUiColor.primary : Colors.black87,
                                  size: 16,
                                ),
                                onPressed: () async {
                                  if (homeViewModel.isLoggedIn) {
                                    if (isInBookMarks) {
                                      await homeViewModel.removeProductFromBookmarks(context: context, productId: product?.id ?? widget.productID);
                                    } else {
                                      await homeViewModel.addProductToBookmarks(context: context, productId: product?.id ?? widget.productID);
                                    }
                                    if (mounted) setState(() => isInBookMarks = !isInBookMarks);
                                  } else {
                                    const SignUpOptionsScreenRoute(UserType.customer).push(context);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Trust Badges Box (Matching Website)
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF059669)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "100% Protected Kudu Purchase Guarantee",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFF2563EB)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Direct Dispatch & Delivery Tracking",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.replay_rounded, size: 16, color: AppUiColor.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Return Policy: ${product?.returnPolicy != null && product!.returnPolicy!.isNotEmpty ? product!.returnPolicy! : 'YES'}",
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: isVehicleOrProperty
              ? Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: AppButton(
                          text: 'Make an Offer',
                          variant: AppButtonVariant.primary,
                          icon: const Icon(Icons.local_offer_outlined, color: Colors.white, size: 18),
                          onPressed: () => _openMakeOfferModal(context),
                        ),
                      ),
                    ),
                    if (product?.vendor?.phoneNumber != null && product!.vendor!.phoneNumber!.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 48,
                        child: AppButton(
                          text: 'Call Seller',
                          variant: AppButtonVariant.outline,
                          icon: const Icon(Icons.phone_outlined, size: 18),
                          onPressed: () {
                            final tel = product?.vendor?.phoneNumber ?? "";
                            launchUrl(Uri.parse("tel:$tel"));
                          },
                        ),
                      ),
                    ],
                  ],
                )
              : Row(
                  children: [
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (quantityToAdd > 1) {
                                setState(() {
                                  quantityToAdd--;
                                });
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.remove_rounded, size: 18),
                            ),
                          ),
                          Text(
                            "$quantityToAdd",
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                quantityToAdd++;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.add_rounded, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: AppButton(
                          text: 'Add to Cart',
                          variant: AppButtonVariant.outline,
                          icon: SvgPicture.asset(
                            AppUiIcon.cart,
                            height: 18,
                            width: 18,
                            colorFilter: const ColorFilter.mode(AppUiColor.primary, BlendMode.srcIn),
                          ),
                          onPressed: () async {
                            if (homeViewModel.isLoggedIn) {
                              await addToCart();
                              await loadCartCount();
                            } else {
                              const SignUpOptionsScreenRoute(UserType.customer).push(context);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: AppButton(
                          text: 'Buy Now',
                          variant: AppButtonVariant.primary,
                          icon: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
                          onPressed: handleBuyNow,
                        ),
                      ),
                    ),
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
