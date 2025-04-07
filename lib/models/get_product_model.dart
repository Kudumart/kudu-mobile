// To parse this JSON data, do
//
//     final getProductModel = getProductModelFromJson(jsonString);

import 'dart:convert';

GetProductModel getProductModelFromJson(String str) =>
    GetProductModel.fromJson(json.decode(str));

String getProductModelToJson(GetProductModel data) =>
    json.encode(data.toJson());

class GetProductModel {
  String? id;
  String? vendorId;
  String? storeId;
  String? categoryId;
  String? name;
  String? sku;
  String? condition;
  String? description;
  String? specification;
  String? price;
  String? discountPrice;
  String? imageUrl;
  List<String>? additionalImages;
  String? warranty;
  String? returnPolicy;
  String? seoTitle;
  String? metaDescription;
  String? keywords;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  SubCategory? subCategory;
  Store? store;

  dynamic bidIncrement;
  dynamic maxBidsPerUser;
  dynamic participantsInterestFee;
  dynamic startDate;
  dynamic endDate;
  dynamic auctionStatus;

  GetProductModel({
    this.id,
    this.vendorId,
    this.storeId,
    this.categoryId,
    this.name,
    this.sku,
    this.condition,
    this.description,
    this.specification,
    this.price,
    this.discountPrice,
    this.imageUrl,
    this.additionalImages,
    this.warranty,
    this.returnPolicy,
    this.seoTitle,
    this.metaDescription,
    this.keywords,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.subCategory,
    this.store,

    this.bidIncrement,
    this.maxBidsPerUser,
    this.participantsInterestFee,
    this.startDate,
    this.endDate,
    this.auctionStatus,
  });

  GetProductModel copyWith({
    String? id,
    String? vendorId,
    String? storeId,
    String? categoryId,
    String? name,
    String? sku,
    String? condition,
    String? description,
    String? specification,
    String? price,
    String? discountPrice,
    String? imageUrl,
    List<String>? additionalImages,
    String? warranty,
    String? returnPolicy,
    String? seoTitle,
    String? metaDescription,
    String? keywords,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    SubCategory? subCategory,
    Store? store,

    dynamic bidIncrement,
  }) =>
      GetProductModel(
        id: id ?? this.id,
        vendorId: vendorId ?? this.vendorId,
        storeId: storeId ?? this.storeId,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        sku: sku ?? this.sku,
        condition: condition ?? this.condition,
        description: description ?? this.description,
        specification: specification ?? this.specification,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        imageUrl: imageUrl ?? this.imageUrl,
        additionalImages: additionalImages ?? this.additionalImages,
        warranty: warranty ?? this.warranty,
        returnPolicy: returnPolicy ?? this.returnPolicy,
        seoTitle: seoTitle ?? this.seoTitle,
        metaDescription: metaDescription ?? this.metaDescription,
        keywords: keywords ?? this.keywords,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        subCategory: subCategory ?? this.subCategory,
        store: store ?? this.store,
      );

  factory GetProductModel.fromJson(Map<String, dynamic> json) =>
      GetProductModel(
        id: json["id"],
        vendorId: json["vendorId"],
        storeId: json["storeId"],
        categoryId: json["categoryId"],
        name: json["name"],
        sku: json["sku"],
        condition: json["condition"],
        description: json["description"],
        specification: json["specification"],
        price: json["price"],
        discountPrice: json["discount_price"],
        imageUrl: json["image_url"],
        additionalImages: json['additional_images'] != null ? (json['additional_images'] as List).map((i) => i.toString()).toList() : [],
        warranty: json["warranty"],
        returnPolicy: json["return_policy"],
        seoTitle: json["seo_title"],
        metaDescription: json["meta_description"],
        keywords: json["keywords"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        subCategory: json["sub_category"] == null
            ? null
            : SubCategory.fromJson(json["sub_category"]),
        store: json["store"] == null ? null : Store.fromJson(json["store"]),

        bidIncrement: json["bidIncrement"],
        maxBidsPerUser: json["maxBidsPerUser"],
        participantsInterestFee: json["participantsInterestFee"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        auctionStatus: json["auctionStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendorId": vendorId,
        "storeId": storeId,
        "categoryId": categoryId,
        "name": name,
        "sku": sku,
        "condition": condition,
        "description": description,
        "specification": specification,
        "price": price,
        "discount_price": discountPrice,
        "image_url": imageUrl,
        "additional_images": jsonEncode(additionalImages ?? []),
        "warranty": warranty,
        "return_policy": returnPolicy,
        "seo_title": seoTitle,
        "meta_description": metaDescription,
        "keywords": keywords,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "sub_category": subCategory?.toJson(),
        "store": store?.toJson(),
        "bidIncrement": bidIncrement,
        "maxBidsPerUser": maxBidsPerUser,
        "participantsInterestFee": participantsInterestFee,
        "startDate": startDate,
        "endDate": endDate,
        "auctionStatus": auctionStatus,
      };

  bool get isAuction {
    return auctionStatus != null;
  }
}

class Store {
  String? name;
  Currency? currency;

  Store({
    this.name,
    this.currency,
  });

  Store copyWith({
    String? name,
    Currency? currency,
  }) =>
      Store(
        name: name ?? this.name,
        currency: currency ?? this.currency,
      );

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        name: json["name"],
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "currency": currency?.toJson(),
      };
}

class Currency {
  String? symbol;

  Currency({
    this.symbol,
  });

  Currency copyWith({
    String? symbol,
  }) =>
      Currency(
        symbol: symbol ?? this.symbol,
      );

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
      };
}

class SubCategory {
  String? id;
  String? categoryId;
  String? image;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  SubCategory({
    this.id,
    this.categoryId,
    this.image,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  SubCategory copyWith({
    String? id,
    String? categoryId,
    String? image,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      SubCategory(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        image: image ?? this.image,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        categoryId: json["categoryId"],
        image: json["image"],
        name: json["name"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryId": categoryId,
        "image": image,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
