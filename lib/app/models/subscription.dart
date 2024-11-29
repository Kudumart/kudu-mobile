import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final String name;
  final double price;
  final String currency;
  final List<String> benefits;
  final bool isActive;
  const Subscription(
      {required this.name,
      required this.price,
      required this.currency,
      required this.isActive,
      required this.benefits});

  @override
  List<Object?> get props => [name, price, currency, benefits, isActive];
}
