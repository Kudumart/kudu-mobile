// To parse this JSON data, do
//
//     final currencyModel = currencyModelFromJson(jsonString);

import 'dart:convert';

CurrencyModel currencyModelFromJson(String str) =>
    CurrencyModel.fromJson(json.decode(str));

String currencyModelToJson(CurrencyModel data) => json.encode(data.toJson());

class CurrencyModel {
  List<CurrencyData>? data;

  CurrencyModel({
    this.data,
  });

  CurrencyModel copyWith({
    List<CurrencyData>? data,
  }) =>
      CurrencyModel(
        data: data ?? this.data,
      );

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        data: json["data"] == null
            ? []
            : List<CurrencyData>.from(
                json["data"]!.map((x) => CurrencyData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CurrencyData {
  String? id;
  String? name;
  String? symbol;
  DateTime? createdAt;
  DateTime? updatedAt;

  CurrencyData({
    this.id,
    this.name,
    this.symbol,
    this.createdAt,
    this.updatedAt,
  });

  CurrencyData copyWith({
    String? id,
    String? name,
    String? symbol,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      CurrencyData(
        id: id ?? this.id,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory CurrencyData.fromJson(Map<String, dynamic> json) => CurrencyData(
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
