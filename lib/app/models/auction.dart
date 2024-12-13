import 'package:equatable/equatable.dart';
import 'package:kudu/app/models/enums_and_extensions.dart';

class Auction extends Equatable {
  final String id;
  final String storeID;
  final String categoryID;
  final String name;
  final String location;
  final ProductCondition condition;
  final String? description;
  final Map<String, dynamic> specification;
  final double minimumBidPrice;
  final double? bidIncrement;

  /// the minimum amount the auction creator is willing to sell the auctioned product for.
  final double minimumSalePrice;
  final int maxBidPerUser;
  final double participantsInterestFee;
  final DateTime starts;
  final DateTime ends;
  final String image;
  final double currentHighestBid;
  final List<String> additionalImages;
  final DateTime createdOn;

  const Auction(
      {required this.id,
      required this.storeID,
      required this.categoryID,
      required this.name,
      required this.location,
      required this.condition,
      required this.description,
      required this.specification,
      required this.minimumBidPrice,
      required this.minimumSalePrice,
      required this.bidIncrement,
      required this.maxBidPerUser,
      required this.participantsInterestFee,
      required this.starts,
      required this.ends,
      required this.image,
      required this.createdOn,
      required this.currentHighestBid,
      required this.additionalImages});

  Duration timeLeft() {
    return DateTime.now().difference(ends);
  }

  String formattedTimeLeft() {
    final duration = timeLeft();
    assert(duration.inSeconds < 0, "Duration must be greater than zero.");

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    final StringBuffer buffer = StringBuffer();
    bool showSeconds = true;
    if (days > 0) {
      buffer.write('${days}D ');
      showSeconds = false;
    }
    if (hours > 0) {
      buffer.write('${hours}H ');
    }
    if (minutes > 0) {
      buffer.write('${minutes}min ');
    }
    if (showSeconds && seconds > 0) {
      buffer.write('${seconds}s');
    }

    return buffer.toString().trim();
  }

  AuctionStatus status() {
    final today = DateTime.now();
    if (starts.isAfter(today)) {
      return AuctionStatus.upcoming;
    }
    if (ends.isBefore(today)) {
      return AuctionStatus.closed;
    }
    if (starts.isBefore(today) && ends.isAfter(today)) {
      return AuctionStatus.ongoing;
    }

    return AuctionStatus.unknown;
  }

  @override
  List<Object?> get props => [
        id,
        storeID,
        categoryID,
        name,
        condition,
        description,
        specification,
        minimumBidPrice,
        bidIncrement,
        maxBidPerUser,
        participantsInterestFee,
        starts,
        ends,
        image,
        additionalImages,
        createdOn
      ];
}
