import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../core/shared_widgets/overlay/overlay.dart';
import '../../providers/home_provider.dart';
import '../cart/create_shipping_address.dart';
import '../orders/order_main_screen.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  bool _loading = true;
  List<dynamic> _offers = [];

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    setState(() => _loading = true);
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    final offers = await homeViewModel.fetchMyOffers(context: context);
    if (mounted) {
      setState(() {
        _offers = offers;
        _loading = false;
      });
    }
  }

  String _formatMoney(dynamic amount, [String symbol = "₦"]) {
    final numVal = num.tryParse(amount?.toString() ?? "0") ?? 0;
    return NumberFormat.currency(locale: "en-US", symbol: symbol).format(numVal);
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return const Color(0xFF16A34A);
      case 'countered':
        return Colors.blue;
      case 'completed':
        return const Color(0xFF0D9488);
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return "Waiting for Seller";
      case 'countered':
        return "Seller Countered";
      case 'accepted':
        return "Ready for Payment";
      case 'rejected':
        return "Offer Declined";
      case 'completed':
        return "Order Placed";
      default:
        return status ?? "Pending";
    }
  }

  Future<void> _handleRespond(String offerId, String responseStatus) async {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    final success = await homeViewModel.respondToOffer(
      context: context,
      offerId: offerId,
      status: responseStatus,
    );
    if (success && mounted) {
      await _loadOffers();
    }
  }

  Future<void> _handlePayOffer(dynamic offer) async {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    final location = homeViewModel.userData?.location;
    final addressText = [
      (location?.address ?? "").trim(),
      (location?.city ?? "").trim(),
      (location?.state ?? "").trim(),
      (location?.country ?? "").trim(),
    ].where((s) => s.isNotEmpty).join(", ");

    if (addressText.isEmpty || (location?.address ?? "").trim().isEmpty) {
      AppUiOverlay().showErrorSnackbarMessage(
        context,
        message: "Please set your delivery address before completing payment",
      );
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (context) => const CreateShippingAddress()),
      );
      return;
    }

    final offerId = offer['id']?.toString() ?? "";
    final payableAmount = (num.tryParse(
          offer['counterPrice']?.toString() ?? offer['offeredPrice']?.toString() ?? "0",
        ) ??
        0).toDouble();

    AppUiOverlay.showLoadingIndicator(context);
    final prepared = await homeViewModel.initiateOfferPayment(
      context: context,
      offerId: offerId,
    );
    AppUiOverlay.dismissLoadingIndicator();

    if (prepared == null) return;

    final refId = prepared['refId']?.toString() ?? "";
    if (refId.isEmpty) {
      if (mounted) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Payment session could not be established");
      }
      return;
    }

    final payResult = await homeViewModel.initiatePayment(
      context: context,
      amount: payableAmount,
      reference: refId,
    );

    if (payResult != null && payResult.reference != null && payResult.reference!.isNotEmpty) {
      AppUiOverlay.showLoadingIndicator(context);
      final checkedOut = await homeViewModel.checkoutOffer(
        context: context,
        offerId: offerId,
        refId: payResult.reference!,
        shippingAddress: addressText,
      );
      AppUiOverlay.dismissLoadingIndicator();

      if (checkedOut && mounted) {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const OrderMainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          "My Offers & Negotiations",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _offers.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadOffers,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _offers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final offer = _offers[index];
                      return _buildOfferCard(offer);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppUiColor.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_offer_outlined, size: 48, color: AppUiColor.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              "No Active Offers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              "You can negotiate prices directly with sellers on KuduMart. Tap 'Make an Offer' on any product page to submit your proposed price.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(dynamic offer) {
    final product = offer['product'] as Map<String, dynamic>?;
    final productName = product?['name']?.toString() ?? "Product";
    final productImage = product?['image_url']?.toString() ?? "";
    final originalPrice = product?['price'];
    final offeredPrice = offer['offeredPrice'];
    final counterPrice = offer['counterPrice'];
    final status = offer['status']?.toString() ?? "pending";
    final message = offer['message']?.toString();
    final offerId = offer['id']?.toString() ?? "";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product info & Status Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (productImage.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productImage,
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 54,
                        height: 54,
                        color: Colors.grey[100],
                        child: const Icon(Icons.image_not_supported_outlined, size: 20),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Listed: ${_formatMoney(originalPrice)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _statusLabel(status),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _statusColor(status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),

            // Negotiation amounts
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Your Offered Price", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 2),
                      Text(
                        _formatMoney(offeredPrice),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                if (counterPrice != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Seller's Counteroffer", style: TextStyle(fontSize: 11, color: Colors.blue)),
                        const SizedBox(height: 2),
                        Text(
                          _formatMoney(counterPrice),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            if (message != null && message.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "Note: \"$message\"",
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[700]),
              ),
            ],

            // Actions for Countered Status
            if (status == 'countered') ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[700],
                        side: BorderSide(color: Colors.red[200]!),
                      ),
                      onPressed: () => _handleRespond(offerId, 'rejected'),
                      child: const Text("Decline"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppUiColor.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _handleRespond(offerId, 'accepted'),
                      child: const Text("Accept Counter"),
                    ),
                  ),
                ],
              ),
            ],

            // Actions for Accepted Status (Ready for Payment)
            if (status == 'accepted') ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.payment_rounded, size: 18),
                  label: Text("Pay ${_formatMoney(counterPrice ?? offeredPrice)} & Order"),
                  onPressed: () => _handlePayOffer(offer),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
