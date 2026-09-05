part of '../screen.dart';

class _BidInformation extends StatefulWidget {
  final ProductData product;
  const _BidInformation(this.product);

  @override
  State<_BidInformation> createState() => _BidInformationState();
}

class _BidInformationState extends State<_BidInformation> {
  late ProductData _product;
  late double _selectedBidAmount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _selectedBidAmount = _calculateNextAcceptableBid();
    _refreshProduct();
  }

  void _refreshProduct() async {
    final prodId = _product.id;
    if (prodId == null || prodId.isEmpty) return;
    final homeProvider = Provider.of<HomeViewModel>(context, listen: false);
    final fresh = await homeProvider.fetchSingleAuctionProduct(prodId);
    if (fresh != null && mounted) {
      setState(() {
        _product = fresh;
        final nextAcceptable = _calculateNextAcceptableBid();
        if (_selectedBidAmount < nextAcceptable) {
          _selectedBidAmount = nextAcceptable;
        }
      });
    }
  }

  double _calculateNextAcceptableBid() {
    final basePrice = num.tryParse(_product.price ?? "0") ?? 0.0;
    final incPrice = num.tryParse(_product.bidIncrement ?? "0") ?? 0.0;
    return (basePrice + incPrice).toDouble();
  }

  String get _currency => _product.store?.currency?.symbol ?? "₦";

  bool get _isEnded {
    if (_product.auctionStatus?.toLowerCase() == "ended") return true;
    final endDate = DateTime.tryParse(_product.endDate ?? "")?.toUtc();
    if (endDate != null && DateTime.now().toUtc().isAfter(endDate)) return true;
    return false;
  }

  bool get _isUpcoming {
    if (_product.auctionStatus?.toLowerCase() == "upcoming") return true;
    final startDate = DateTime.tryParse(_product.startDate ?? "")?.toUtc();
    if (startDate != null && DateTime.now().toUtc().isBefore(startDate)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 27, 16, 22),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(7)),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Bid Information",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ),
          const SizedBox(height: 18),
          _InfoNameAndValue(
              infoName: "Minimum Bid",
              infoValue: minBid()),
          _InfoNameAndValue(
              infoName: "Time Left",
              infoValueTextColor: const Color(0xFFFF0F00),
              infoValue: timeRemaining()),
          _InfoNameAndValue(
              infoName: "Current Bid",
              infoValue: formatPrice(),
          ),
          _InfoNameAndValue(
              infoName: "Next Acceptable Bid",
              infoValue: nextAcceptableBid()),
          const SizedBox(height: 9),
          _JoinBidButton(
              joinPrice: (num.tryParse(_product.participantsInterestFee ?? "0") ?? 0.0).toDouble(),
              currency: _currency),
          const SizedBox(height: 27),
          if (!_isEnded && !_isUpcoming) ...[
            _BidPriceInput(
              minimumPrice: _calculateNextAcceptableBid(),
              incrementFactor: (num.tryParse(_product.bidIncrement ?? "0") ?? 1.0).toDouble(),
              currency: _currency,
              onPriceChanged: (newPrice) {
                setState(() {
                  _selectedBidAmount = newPrice;
                });
              },
            ),
            const SizedBox(height: 31),
            Text(
              "*Change Factor ${minBid()}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 13),
          ],
          ElevatedButton(
              onPressed: (_isEnded || _isUpcoming || _isLoading)
                  ? null
                  : () async {
                      final prodId = _product.id;
                      if (prodId == null || prodId.isEmpty) return;
                      setState(() => _isLoading = true);
                      final homeProvider = Provider.of<HomeViewModel>(context, listen: false);
                      final success = await homeProvider.placeBid(
                        context: context,
                        auctionProductId: prodId,
                        bidAmount: _selectedBidAmount,
                      );
                      if (mounted) {
                        setState(() => _isLoading = false);
                        if (success) {
                          _refreshProduct();
                        }
                      }
                    },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.resolveWith<Size>(
                    (_) => const Size(double.infinity, 49)),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey.shade400;
                      }
                      return const Color(0xFF5931FF);
                    }),
                shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
              ),
              child: Text(
                _isEnded
                    ? "AUCTION ENDED"
                    : _isUpcoming
                        ? "AUCTION NOT STARTED"
                        : _isLoading
                            ? "SUBMITTING BID..."
                            : "SUBMIT BID AT $_currency${_selectedBidAmount.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ))
        ],
      ),
    );
  }

  List<String> get productImages {
    var listToReturn = <String>[];
    if (_product.imageUrl != null) {
      listToReturn.add(_product.imageUrl ?? "");
    }
    if (_product.additionalImages != null) {
      _product.additionalImages?.forEach((e) {
        listToReturn.add(e.toString());
      });
    }
    listToReturn = listToReturn.toSet().toList();
    return listToReturn;
  }

  String formatPrice() {
    final format = NumberFormat.currency(locale: "en-US", symbol: _currency);
    return format.format(num.tryParse(_product.price ?? "") ?? 0);
  }

  String minBid() {
    final format = NumberFormat.currency(locale: "en-US", symbol: _currency);
    return format.format(num.tryParse(_product.bidIncrement ?? "") ?? 0);
  }

  String maxBid() {
    return "Unlimited";
  }

  String nextAcceptableBid() {
    return PriceFormatter.formatPrice(
        price: _calculateNextAcceptableBid(),
        currency: _currency);
  }

  String get description {
    var description = _product.description;
    var otherDetails = _product.specification;
    if ((description ?? "").isEmpty && (otherDetails ?? "").isEmpty) {
      return "Seller didn't provide any description of this product at this time. Kindly reach out to the seller to get more direct and up-to-date information about the product";
    }

    return "${description?.trim()}\n\n${otherDetails?.trim()}";
  }

  String get location {
    if (_product.store == null || _product.store?.location == null) {
      return "Not Available";
    }
    try {
      var city = _product.store?.location?.city?.toString().trim() ?? "";
      var state = _product.store?.location?.state?.toString().trim() ?? "";
      var country = _product.store?.location?.country?.toString().trim() ?? "";

      var stringToReturn = city;
      if (city != state && state.isNotEmpty) {
        stringToReturn += ", $state";
      }
      if (city != country && country.isNotEmpty) {
        stringToReturn += ", $country";
      }
      return stringToReturn;
    } catch (_) {
      return "Not Available";
    }
  }

  Map<String, dynamic> get specs {
    return {
      "Condition": _product.condition?.toProductCondition.printableName(),
      "Current Bid": _product.price != null ? formatPrice() : "No Bids Yet",
      "Status": _product.auctionStatus?.capitalizeFirst ?? "Not Started",
    };
  }

  String timeRemaining() {
    final endDateStr = _product.endDate;
    final startDateStr = _product.startDate;
    if (endDateStr == null || endDateStr.isEmpty) return "N/A";

    final now = DateTime.now().toUtc();
    final endDate = DateTime.tryParse(endDateStr)?.toUtc() ?? now;
    final startDate = DateTime.tryParse(startDateStr ?? "")?.toUtc() ?? now;

    if (now.isBefore(startDate)) {
      final diff = startDate.difference(now);
      return "${diff.inDays}d ${diff.inHours % 24}h ${diff.inMinutes % 60}m (Starts soon)";
    }

    if (now.isAfter(endDate) || _isEnded) {
      return "Auction Ended";
    }

    final difference = endDate.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) {
      return "$days days, $hours hrs, $minutes mins";
    } else if (hours > 0) {
      return "$hours hrs, $minutes mins";
    } else {
      final seconds = difference.inSeconds % 60;
      return "$minutes mins, $seconds secs";
    }
  }
}