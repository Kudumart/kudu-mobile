import 'package:equatable/equatable.dart';
import 'package:kudu/models/auction.dart';

import 'home/products_list_model.dart';

class Bid extends Equatable {
  final Auction auction;
  final String id;
  final double price;
  final DateTime created;
  final ProductData? product;

  const Bid(
      {required this.auction,
      required this.id,
      required this.price,
      required this.created,this.product});

  @override
  List<Object?> get props => [id, auction, price, created];
}
