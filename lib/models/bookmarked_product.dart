import 'package:equatable/equatable.dart';

import 'product.dart';

class BookmarkedProduct extends Equatable {
  final DateTime on;
  final Product product;

  const BookmarkedProduct({required this.on, required this.product});

  @override
  List<Object?> get props => [on, product];
}
