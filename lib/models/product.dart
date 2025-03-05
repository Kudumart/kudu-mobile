import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import 'enums_and_extensions.dart';

class Product extends Equatable {
  final String id;
  final List<String>? imagesUrl;
  final ProductCondition condition;
  final double price;
  final String name;
  final String currencySymbol;
  final String location;
  final String? sellerPhoneNumber;
  final String? description;
  final double? rating;
  final String? productId;
  final String? vendorId;
  final String? storeId;
  const Product(
      {this.id = "temporary-id",
      this.imagesUrl,
      required this.name,
      required this.condition,
      this.currencySymbol = "\$",
      required this.price,
      this.description,
      this.rating,
      required this.location,
      this.sellerPhoneNumber,this.productId,this.vendorId,this.storeId});

  /// [formatPrice] outputs a Ui friendly format for [Product] price.
  /// For example, if price = 25000, and currency = $,
  /// print(formatPrice) will print $25,000
  String formatPrice() {
    final format =
        NumberFormat.currency(locale: "en-US", symbol: currencySymbol);
    return format.format(price);
  }

  @override
  List<Object?> get props => [
        id,
        imagesUrl,
        condition,
        price,
        rating,
        location,
        name,
        sellerPhoneNumber
      ];
}
