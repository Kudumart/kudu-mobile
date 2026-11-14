import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:kudu/models/home/cart_list_model.dart';
import 'package:provider/provider.dart';

import '../../models/search_filter.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../providers/home_provider.dart';
import '../installments/installments_screen.dart';
import '../orders/order_main_screen.dart';
import 'create_shipping_address.dart';
import '../../core/shared_widgets/overlay/overlay.dart';

class CartScreen extends StatefulWidget {
  final SearchFilter? searchFilter;
  const CartScreen({this.searchFilter, super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartListModel? products;
  bool loading = false;
  bool checkingOut = false;
  late HomeViewModel provider;

  // Checkout Options
  String deliveryMethod = 'delivery'; // 'delivery' or 'pickup'
  bool useWallet = false;
  bool isLayaway = false;
  int depositPercentage = 25; // 20, 25, 30, 50
  String tenureId = '1_month'; // '1_month', '2_months', '3_months'
  Map<String, dynamic>? installmentConfig;
  double deliveryFee = 0.0;
  bool loadingDeliveryFee = false;

  double get minInstallmentAmount {
    return (num.tryParse(installmentConfig?['min_order_amount']?.toString() ?? "25000") ?? 25000).toDouble();
  }

  double get maxInstallmentAmount {
    return (num.tryParse(installmentConfig?['max_order_amount']?.toString() ?? "2000000") ?? 2000000).toDouble();
  }

  bool get isInstallmentEligible {
    final mode = installmentConfig?['system_mode']?.toString();
    if (mode == 'disabled') return false;
    final itemsCount = products?.data?.length ?? 0;
    // Layaway installment plans lock and reserve a single product line
    if (itemsCount != 1) return false;
    return itemsSubtotal >= minInstallmentAmount && itemsSubtotal <= maxInstallmentAmount;
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
      _loadInstallmentConfig();
    });
  }

  Future<void> _loadInstallmentConfig() async {
    final cfg = await provider.fetchInstallmentConfig();
    if (mounted && cfg != null) {
      setState(() {
        installmentConfig = cfg;
        if (!isInstallmentEligible && isLayaway) {
          isLayaway = false;
        }
      });
    }
  }

  Future<void> _updateDeliveryFee() async {
    if (products == null || (products?.data ?? []).isEmpty) {
      if (mounted) setState(() => deliveryFee = 0.0);
      return;
    }
    setState(() => loadingDeliveryFee = true);
    final fee = await provider.fetchDeliveryFee(countryCode: 'NG');
    if (mounted) {
      setState(() {
        deliveryFee = fee;
        loadingDeliveryFee = false;
      });
    }
  }

  Future<void> getProducts({String? searchTerm}) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    products = await provider.fetchCart(context: context);
    if (mounted) {
      setState(() {
        loading = false;
        if (!isInstallmentEligible && isLayaway) {
          isLayaway = false;
        }
      });
      _updateDeliveryFee();
    }
  }

  double get itemsSubtotal {
    return (products?.data ?? []).fold(
      0.0,
      (previousValue, element) =>
          previousValue +
          (element.itemPrice.toDouble() * (element.quantity?.toInt() ?? 0)),
    );
  }

  double get effectiveDeliveryFee {
    return deliveryMethod == 'delivery' ? deliveryFee : 0.0;
  }

  double get orderTotal {
    return itemsSubtotal + effectiveDeliveryFee;
  }

  double get totalPrice => itemsSubtotal;

  String get currency {
    return (products?.data ?? []).isNotEmpty
        ? products?.data?.first.product?.store?.currency?.symbol ?? "₦"
        : "₦";
  }

  double get walletBalance {
    return num.tryParse(provider.userData?.wallet?.toString() ?? "0")
            ?.toDouble() ??
        0.0;
  }

  double get layawayDepositAmount {
    return (orderTotal * depositPercentage) / 100;
  }

  double get layawayRemainingBalance {
    return orderTotal - layawayDepositAmount;
  }

  double get walletDeduction {
    if (!useWallet || walletBalance <= 0) return 0.0;
    final base = isLayaway ? layawayDepositAmount : orderTotal;
    return walletBalance > base ? base : walletBalance;
  }

  double get amountPayableToday {
    final base = isLayaway ? layawayDepositAmount : orderTotal;
    final net = base - walletDeduction;
    return net > 0 ? net : 0.0;
  }

  String get shippingAddress {
    var location = provider.userData?.location;
    var address = (location?.address ?? "").trim();
    var city = (location?.city ?? "").trim();
    var state = (location?.state ?? "").trim();
    var country = (location?.country ?? "").trim();
    var parts = <String>[];
    if (address.isNotEmpty) parts.add(address);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (country.isNotEmpty) parts.add(country);
    return parts.join(", ");
  }

  bool get hasStreetAddress {
    var location = provider.userData?.location;
    return (location?.address ?? "").trim().isNotEmpty;
  }

  String _formatMoney(double amount) {
    return NumberFormat.currency(locale: "en-US", symbol: currency).format(amount);
  }

  Future<void> _handleCheckout() async {
    if (deliveryMethod == 'delivery' &&
        (shippingAddress.trim().isEmpty || !hasStreetAddress)) {
      AppUiOverlay().showErrorSnackbarMessage(context,
          message:
              "Please provide your full delivery address (including street address) before checking out");
      await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) => const CreateShippingAddress()));
      if (mounted) setState(() {});
      return;
    }

    if (totalPrice <= 0) {
      AppUiOverlay().showErrorSnackbarMessage(context,
          message: "Your cart has no payable items");
      return;
    }

    setState(() => checkingOut = true);
    AppUiOverlay.showLoadingIndicator(context);

    try {
      if (isLayaway) {
        final firstItem = (products?.data ?? []).first;
        final productId = firstItem.productId ?? firstItem.product?.id ?? "";
        final qty = firstItem.quantity?.toInt() ?? 1;

        final prepared = await provider.prepareInstallmentCheckout(
          context: context,
          productId: productId,
          quantity: qty,
          tenureId: tenureId,
          depositPercentage: depositPercentage,
          shippingAddress:
              deliveryMethod == 'pickup' ? "Store Pickup" : shippingAddress,
          deliveryMethod: deliveryMethod,
          deliveryFee: effectiveDeliveryFee,
          useWallet: useWallet,
        );

        AppUiOverlay.dismissLoadingIndicator();

        if (prepared == null) {
          setState(() => checkingOut = false);
          return;
        }

        final isPureWallet = prepared['paidWithWallet'] == true;
        final refId = prepared['refId']?.toString() ?? "";
        final payAmount =
            (num.tryParse(prepared['amountToPay']?.toString() ?? "0") ?? 0)
                .toDouble();

        final payload = {
          "refId": refId,
          "productId": productId,
          "quantity": qty,
          "tenureId": tenureId,
          "depositPercentage": depositPercentage,
          "shippingAddress":
              deliveryMethod == 'pickup' ? "Store Pickup" : shippingAddress,
          "deliveryMethod": deliveryMethod,
          "deliveryFee": effectiveDeliveryFee,
          "useWallet": useWallet,
        };

        if (isPureWallet && refId.isNotEmpty) {
          AppUiOverlay.showLoadingIndicator(context);
          final confirmed = await provider.confirmInstallmentCheckout(
              context: context, payload: payload);
          AppUiOverlay.dismissLoadingIndicator();
          if (confirmed && mounted) {
            await getProducts();
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const InstallmentsScreen(),
              ),
            );
          }
        } else {
          final payResult = await provider.initiatePayment(
            context: context,
            amount: payAmount > 0 ? payAmount : layawayDepositAmount,
            reference: refId,
          );

          if (payResult != null &&
              payResult.reference != null &&
              payResult.reference!.isNotEmpty) {
            payload["refId"] = payResult.reference!;
            AppUiOverlay.showLoadingIndicator(context);
            final confirmed = await provider.confirmInstallmentCheckout(
                context: context, payload: payload);
            AppUiOverlay.dismissLoadingIndicator();
            if (confirmed && mounted) {
              await getProducts();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const InstallmentsScreen(),
                ),
              );
            }
          }
        }
      } else {
        final prepared = await provider.prepareCheckoutNaira(
          context: context,
          deliveryMethod: deliveryMethod,
          useWallet: useWallet,
        );

        AppUiOverlay.dismissLoadingIndicator();

        if (prepared == null) {
          setState(() => checkingOut = false);
          return;
        }

        final isPureWallet = prepared['paidWithWallet'] == true;
        final refId = prepared['refId']?.toString() ?? "";
        final payAmount =
            (num.tryParse(prepared['amountToPay']?.toString() ?? "0") ?? 0)
                .toDouble();

        if (isPureWallet && refId.isNotEmpty) {
          AppUiOverlay.showLoadingIndicator(context);
          final res = await provider.confirmProductCheckout(
            context: context,
            address:
                deliveryMethod == 'pickup' ? "Store Pickup" : shippingAddress,
            reference: refId,
            deliveryMethod: deliveryMethod,
            useWallet: useWallet,
          );
          AppUiOverlay.dismissLoadingIndicator();
          if (res && mounted) {
            await getProducts();
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const OrderMainScreen(),
              ),
            );
          }
        } else {
          final payResult = await provider.initiatePayment(
            context: context,
            amount: payAmount > 0 ? payAmount : amountPayableToday,
            reference: refId,
          );

          if (payResult != null &&
              payResult.reference != null &&
              payResult.reference!.isNotEmpty) {
            AppUiOverlay.showLoadingIndicator(context);
            final res = await provider.confirmProductCheckout(
              context: context,
              address:
                  deliveryMethod == 'pickup' ? "Store Pickup" : shippingAddress,
              reference: payResult.reference!,
              deliveryMethod: deliveryMethod,
              useWallet: useWallet,
            );
            AppUiOverlay.dismissLoadingIndicator();
            if (res && mounted) {
              await getProducts();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const OrderMainScreen(),
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      if (mounted) {
        AppUiOverlay()
            .showErrorSnackbarMessage(context, message: "Checkout error: $e");
      }
    } finally {
      if (mounted) setState(() => checkingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
            UiConstant.horizontalPadding, 0, UiConstant.horizontalPadding, 10),
        child: Builder(builder: (context) {
          if ((products?.data ?? []).isEmpty && !loading) {
            return const Center(child: Text("No Products In Cart"));
          }

          return SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              runSpacing: 19,
              spacing: 5,
              children: (products?.data ?? [])
                  .map((product) => CartItem(
                        key: ValueKey(product.id),
                        cartData: product,
                        onOneAdded: () async {
                          var provider = Provider.of<HomeViewModel>(context,
                              listen: false);
                          await provider.updateProductInCart(
                              context: context,
                              cartId: product.id ?? "",
                              quantity: (product.quantity?.toInt() ?? 0) + 1);
                          getProducts();
                        },
                        onOneRemoved: () async {
                          var provider = Provider.of<HomeViewModel>(context,
                              listen: false);
                          await provider.updateProductInCart(
                              context: context,
                              cartId: product.id ?? "",
                              quantity: (product.quantity?.toInt() ?? 0) - 1);
                          getProducts();
                        },
                        onRemoved: () async {
                          var provider = Provider.of<HomeViewModel>(context,
                              listen: false);
                          await provider.removeProductFromCart(
                              context: context, cartId: product.id ?? "");
                          getProducts();
                        },
                      ))
                  .toList(),
            ),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Order & Payment Options",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              // Delivery Method Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => deliveryMethod = 'delivery'),
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: deliveryMethod == 'delivery' ? AppUiColor.primary : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.local_shipping_outlined,
                                    size: 16,
                                    color: deliveryMethod == 'delivery' ? Colors.white : Colors.black87),
                                const SizedBox(width: 6),
                                Text(
                                  deliveryFee > 0
                                      ? "Door Delivery (${_formatMoney(deliveryFee)})"
                                      : "Door Delivery",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: deliveryMethod == 'delivery' ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => deliveryMethod = 'pickup'),
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: deliveryMethod == 'pickup' ? AppUiColor.primary : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.storefront_outlined,
                                    size: 16,
                                    color: deliveryMethod == 'pickup' ? Colors.white : Colors.black87),
                                const SizedBox(width: 6),
                                Text(
                                  "Store Pickup (₦0)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: deliveryMethod == 'pickup' ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Address Display for Door Delivery with ample spacing below
              if (deliveryMethod == 'delivery') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppUiColor.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          shippingAddress.isEmpty
                              ? "No delivery address set"
                              : shippingAddress,
                          style: TextStyle(
                            fontSize: 12,
                            color: (!hasStreetAddress && shippingAddress.isNotEmpty)
                                ? Colors.deepOrange
                                : Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          await Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateShippingAddress()),
                          );
                          if (mounted) {
                            setState(() {});
                            _updateDeliveryFee();
                          }
                        },
                        child: const Text(
                          "Change",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppUiColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Payment Plan Selector: Full Payment vs Layaway (Installments)
              // Only shown when order is eligible for Layaway
              if (isInstallmentEligible) ...[
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Payment Plan:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    ChoiceChip(
                      label: const Text("Full Payment"),
                      selected: !isLayaway,
                      selectedColor: AppUiColor.primary.withOpacity(0.12),
                      onSelected: (val) => setState(() => isLayaway = false),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: !isLayaway ? FontWeight.w700 : FontWeight.w500,
                        color: !isLayaway ? AppUiColor.primary : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text("Layaway"),
                      selected: isLayaway,
                      selectedColor: AppUiColor.primary.withOpacity(0.12),
                      onSelected: (val) => setState(() => isLayaway = true),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isLayaway ? FontWeight.w700 : FontWeight.w500,
                        color: isLayaway ? AppUiColor.primary : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],

              // Layaway options (if active and eligible)
              if (isInstallmentEligible && isLayaway) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Deposit Percentage (Pay Today)",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [20, 25, 30, 50].map((pct) {
                          final isSel = depositPercentage == pct;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () => setState(() => depositPercentage = pct),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSel ? AppUiColor.primary : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: isSel ? AppUiColor.primary : Colors.grey[300]!),
                                ),
                                child: Text(
                                  "$pct%",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Tenure Duration",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          {"id": "1_month", "label": "1 Month (2x)"},
                          {"id": "2_months", "label": "2 Months (3x)"},
                          {"id": "3_months", "label": "3 Months (4x)"},
                        ].map((t) {
                          final isSel = tenureId == t['id'];
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () => setState(() => tenureId = t['id']!),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSel ? AppUiColor.primary : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: isSel ? AppUiColor.primary : Colors.grey[300]!),
                                ),
                                child: Text(
                                  t['label']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Deposit: ${_formatMoney(layawayDepositAmount)} • Balance: ${_formatMoney(layawayRemainingBalance)}",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppUiColor.primary),
                      ),
                    ],
                  ),
                ),
              ],

              // Wallet Deduction Toggle
              if (walletBalance > 0) ...[
                const SizedBox(height: 6),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    "Apply Wallet Balance (${_formatMoney(walletBalance)})",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  value: useWallet,
                  activeColor: AppUiColor.primary,
                  onChanged: (val) => setState(() => useWallet = val ?? false),
                ),
              ],

              const Divider(height: 1),
              const SizedBox(height: 10),

              // Summary Breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Items Subtotal", style: TextStyle(fontSize: 13, color: Colors.grey)),
                  Text(
                    _formatMoney(itemsSubtotal),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Delivery Fee", style: TextStyle(fontSize: 13, color: Colors.grey)),
                  Text(
                    deliveryMethod == 'pickup'
                        ? "₦0.00 (Store Pickup)"
                        : (loadingDeliveryFee
                            ? "Calculating..."
                            : (effectiveDeliveryFee > 0 ? _formatMoney(effectiveDeliveryFee) : "₦0.00")),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: deliveryMethod == 'pickup' ? const Color(0xFF16A34A) : Colors.black87,
                    ),
                  ),
                ],
              ),
              if (useWallet && walletDeduction > 0) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Wallet Credit", style: TextStyle(fontSize: 13, color: Color(0xFF16A34A))),
                    Text(
                      "- ${_formatMoney(walletDeduction)}",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF16A34A)),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isLayaway ? "Deposit Today ($depositPercentage%)" : "Total Order",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    _formatMoney(amountPayableToday),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppUiColor.primary),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Checkout Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppUiColor.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: checkingOut ? null : _handleCheckout,
                  child: checkingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          isLayaway
                              ? "Activate Layaway • ${_formatMoney(amountPayableToday)}"
                              : "Checkout • ${_formatMoney(amountPayableToday)}",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.cartData,
    this.onRemoved,
    this.onOneAdded,
    this.onOneRemoved,
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
      if (mounted) {
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
          showVerifiedStatus: false,
          overridePrice: widget.cartData.itemPrice,
          bottomWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.cartData.selectedVariant != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppUiColor.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.cartData.selectedVariant!.label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppUiColor.primary,
                      ),
                    ),
                  ),
                ),
              ],
              Row(
                children: [
                  10.width,
                  InkWell(
                    onTap: () {
                      if (quantity > 0) {
                        setState(() {
                          quantity--;
                        });
                        if (quantity == 0) {
                          widget.onRemoved?.call();
                        } else {
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
