// To parse this JSON data, do
//
//     final getSubscriptionModel = getSubscriptionModelFromJson(jsonString);

import 'dart:convert';

GetSubscriptionModel getSubscriptionModelFromJson(String str) =>
    GetSubscriptionModel.fromJson(json.decode(str));

String getSubscriptionModelToJson(GetSubscriptionModel data) =>
    json.encode(data.toJson());

class GetSubscriptionModel {
  String? id;
  String? name;
  int? duration;
  String? price;
  int? productLimit;
  bool? allowsAuction;
  dynamic auctionProductLimit;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isActiveForVendor;

  GetSubscriptionModel({
    this.id,
    this.name,
    this.duration,
    this.price,
    this.productLimit,
    this.allowsAuction,
    this.auctionProductLimit,
    this.createdAt,
    this.updatedAt,
    this.isActiveForVendor,
  });

  GetSubscriptionModel copyWith({
    String? id,
    String? name,
    int? duration,
    String? price,
    int? productLimit,
    bool? allowsAuction,
    dynamic auctionProductLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActiveForVendor,
  }) =>
      GetSubscriptionModel(
        id: id ?? this.id,
        name: name ?? this.name,
        duration: duration ?? this.duration,
        price: price ?? this.price,
        productLimit: productLimit ?? this.productLimit,
        allowsAuction: allowsAuction ?? this.allowsAuction,
        auctionProductLimit: auctionProductLimit ?? this.auctionProductLimit,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isActiveForVendor: isActiveForVendor ?? this.isActiveForVendor,
      );

  factory GetSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      GetSubscriptionModel(
        id: json["id"],
        name: json["name"],
        duration: json["duration"],
        price: json["price"].toString(),
        productLimit: json["productLimit"],
        allowsAuction: json["allowsAuction"],
        auctionProductLimit: json["auctionProductLimit"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        isActiveForVendor: json["isActiveForVendor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "duration": duration,
        "price": price,
        "productLimit": productLimit,
        "allowsAuction": allowsAuction,
        "auctionProductLimit": auctionProductLimit,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "isActiveForVendor": isActiveForVendor,
      };
}
