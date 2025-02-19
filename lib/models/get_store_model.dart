// To parse this JSON data, do
//
//     final getStoreModel = getStoreModelFromJson(jsonString);

import 'dart:convert';

import 'package:kudu/models/home/business_hours_model.dart';
import 'package:kudu/models/home/delivery_options_model.dart';
import 'package:kudu/models/home/location_model.dart';

GetStoreModel getStoreModelFromJson(String str) =>
    GetStoreModel.fromJson(json.decode(str));

String getStoreModelToJson(GetStoreModel data) => json.encode(data.toJson());

class GetStoreModel {
  String? id;
  String? vendorId;
  String? currencyId;
  String? name;
  LocationModel? location;
  BusinessHoursModel? businessHours;
  List<DeliveryOptionsModel>? deliveryOptions;
  String? tipsOnFinding;
  String? logo;
  bool? isVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  Currency? currency;

  GetStoreModel({
    this.id,
    this.vendorId,
    this.currencyId,
    this.name,
    this.location,
    this.businessHours,
    this.deliveryOptions,
    this.tipsOnFinding,
    this.logo,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.currency,
  });

  GetStoreModel copyWith({
    String? id,
    String? vendorId,
    String? currencyId,
    String? name,
    LocationModel? location,
    BusinessHoursModel? businessHours,
    List<DeliveryOptionsModel>? deliveryOptions,
    String? tipsOnFinding,
    String? logo,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Currency? currency,
  }) =>
      GetStoreModel(
        id: id ?? this.id,
        vendorId: vendorId ?? this.vendorId,
        currencyId: currencyId ?? this.currencyId,
        name: name ?? this.name,
        location: location ?? this.location,
        businessHours: businessHours ?? this.businessHours,
        deliveryOptions: deliveryOptions ?? this.deliveryOptions,
        tipsOnFinding: tipsOnFinding ?? this.tipsOnFinding,
        logo: logo ?? this.logo,
        isVerified: isVerified ?? this.isVerified,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        currency: currency ?? this.currency,
      );

  factory GetStoreModel.fromJson(Map<String, dynamic> json) => GetStoreModel(
        id: json["id"],
        vendorId: json["vendorId"],
        currencyId: json["currencyId"],
        name: json["name"],
        location: json['location'] != null ? LocationModel.fromJson(json['location']) : null,
        businessHours: json['businessHours'] != null ? BusinessHoursModel.fromJson(json['businessHours']) : null,
        deliveryOptions: json['deliveryOptions'] != null ? (json['deliveryOptions'] as List).map((i) => DeliveryOptionsModel.fromJson(i)).toList() : null,
        tipsOnFinding: json["tipsOnFinding"],
        logo: json["logo"],
        isVerified: json["isVerified"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendorId": vendorId,
        "currencyId": currencyId,
        "name": name,
        "location": location?.toJson(),
        "businessHours": businessHours?.toJson(),
        "deliveryOptions": deliveryOptions?.map((v) => v.toJson()).toList() ?? [],
        "tipsOnFinding": tipsOnFinding,
        "logo": logo,
        "isVerified": isVerified,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "currency": currency?.toJson(),
      };
}

class Currency {
  String? id;
  String? name;
  String? symbol;
  DateTime? createdAt;
  DateTime? updatedAt;

  Currency({
    this.id,
    this.name,
    this.symbol,
    this.createdAt,
    this.updatedAt,
  });

  Currency copyWith({
    String? id,
    String? name,
    String? symbol,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Currency(
        id: id ?? this.id,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        name: json["name"],
        symbol: json["symbol"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
