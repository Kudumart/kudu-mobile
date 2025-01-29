import 'package:equatable/equatable.dart';
import 'package:kudu/models/auction.dart';

class Bid extends Equatable {
  final Auction auction;
  final String id;
  final double price;
  final DateTime created;

  const Bid(
      {required this.auction,
      required this.id,
      required this.price,
      required this.created});

  @override
  List<Object?> get props => [id, auction, price, created];
}
