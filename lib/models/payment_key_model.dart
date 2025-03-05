// To parse this JSON data, do
//
//     final paymentGetwayKeyModel = paymentGetwayKeyModelFromJson(jsonString);

import 'dart:convert';

PaymentGatewayKeyModel paymentGetwayKeyModelFromJson(String str) =>
    PaymentGatewayKeyModel.fromJson(json.decode(str));

String paymentGetwayKeyModelToJson(PaymentGatewayKeyModel data) =>
    json.encode(data.toJson());

class PaymentGatewayKeyModel {
  PaymentData? data;

  PaymentGatewayKeyModel({
    this.data,
  });

  PaymentGatewayKeyModel copyWith({
    PaymentData? data,
  }) =>
      PaymentGatewayKeyModel(
        data: data ?? this.data,
      );

  factory PaymentGatewayKeyModel.fromJson(Map<String, dynamic> json){
    try{
      return PaymentGatewayKeyModel(
        data: (json["data"] as List).isEmpty ? null : PaymentData.fromJson((json["data"] as List)[0]),
      );
    }catch(_){
      return PaymentGatewayKeyModel(
        data: null,
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class PaymentData {
  String? id;
  String? name;
  String? publicKey;
  String? secretKey;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaymentData({
    this.id,
    this.name,
    this.publicKey,
    this.secretKey,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  PaymentData copyWith({
    String? id,
    String? name,
    String? publicKey,
    String? secretKey,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PaymentData(
        id: id ?? this.id,
        name: name ?? this.name,
        publicKey: publicKey ?? this.publicKey,
        secretKey: secretKey ?? this.secretKey,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        id: json["id"],
        name: json["name"],
        publicKey: json["publicKey"],
        secretKey: json["secretKey"],
        isActive: json["isActive"],
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
        "publicKey": publicKey,
        "secretKey": secretKey,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
