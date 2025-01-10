import 'package:equatable/equatable.dart';

class Store extends Equatable {
  final String name;
  final String address;
  final String country;
  final String state;
  final String city;
  final String? nearestLandMark;
  final DateTime created;
  final int totalActiveProducts;
  final String? logoUrl;
  const Store(
      {required this.created,
      required this.totalActiveProducts,
      required this.name,
      required this.address,
      required this.city,
      required this.country,
      required this.logoUrl,
      required this.state,
      this.nearestLandMark});

  Store.fromJson(Map<String, dynamic> json)
      : name = json["name"] ?? "Default-storename",
        address = json["address"] ?? "Default-address",
        state = json["state"] ?? "Default-state",
        city = json["city"] ?? "Default-city",
        country = json["country"] ?? "Default-country",
        created = DateTime.parse(json["createdOn"]),
        nearestLandMark = json["tipsOnFinding"],
        logoUrl = json["logoUrl"],
        totalActiveProducts = json["totalActiveProduct"] ?? 0;

  @override
  List<Object?> get props => [
        name,
        address,
        state,
        city,
        country,
        created,
        nearestLandMark,
        logoUrl,
        totalActiveProducts
      ];
}
