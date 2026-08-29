import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'business_hours_model.dart';
import 'delivery_options_model.dart';
import 'location_model.dart';
import '../reviews/review_models.dart';
ProductsListModel productsListModelFromJson(String str) => ProductsListModel.fromJson(json.decode(str));
String productsListModelToJson(ProductsListModel data) => json.encode(data.toJson());

class ProductsListModel {
  ProductsListModel({
      this.data,});

  ProductsListModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProductData.fromJson(v));
      });
    }
  }
  List<ProductData>? data;
ProductsListModel copyWith({  List<ProductData>? data,
}) => ProductsListModel(  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

ProductData dataFromJson(String str) => ProductData.fromJson(json.decode(str));
String dataToJson(ProductData data) => json.encode(data.toJson());
class ProductData {
  ProductData({
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
      this.vendor,
      this.subCategory,
      this.store,
    this.recommendedProducts,
    this.averageRating,
    this.totalReviews,
    this.reviews,
  });

  ProductData.fromJson(dynamic json) {
    id = json['id'];
    vendorId = json['vendorId'];
    storeId = json['storeId'];
    categoryId = json['categoryId'];
    name = json['name'];
    sku = json['sku'];
    condition = json['condition'];
    description = json['description'];
    specification = json['specification'];
    price = json['price'];
    discountPrice = json['discount_price'];
    imageUrl = json['image_url'] ?? json['image'];
    additionalImages = json['additional_images'] != null ? (json['additional_images'] as List).map((i) => i.toString()).toList() : (json['additionalImages'] != null ? (json['additionalImages'] as List).map((i) => i.toString()).toList() : null);
    warranty = json['warranty'];
    returnPolicy = json['return_policy'];
    seoTitle = json['seo_title'];
    metaDescription = json['meta_description'];
    keywords = json['keywords'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    subCategory = json['sub_category'] != null ? SubCategory.fromJson(json['sub_category']) : null;
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    recommendedProducts = json['recommendedProducts'] != null ? (json['recommendedProducts'] as List).map((i) => ProductData.fromJson(i)).toList() : null;
    averageRating = num.tryParse(json['averageRating']?.toString() ?? "")?.toDouble();
    totalReviews = num.tryParse(json['totalReviews']?.toString() ?? "")?.toInt();
    reviews = json['reviews'] != null ? (json['reviews'] as List).map((i) => ReviewData.fromJson(i)).toList() : null;

    bidIncrement = json['bidIncrement'].toString();
    maxBidsPerUser = num.tryParse(json['maxBidsPerUser'].toString());
    participantsInterestFee = json['participantsInterestFee'].toString();
    startDate = json['startDate'].toString();
    endDate = json['endDate'].toString();
    auctionStatus = json['auctionStatus'].toString();

    admin = json['admin'];
    quantity = json['quantity'] != null ? num.tryParse(json['quantity'].toString()) : null;
  }
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
  String? createdAt;
  String? updatedAt;
  Vendor? vendor;
  SubCategory? subCategory;
  Store? store;
  List<ProductData>? recommendedProducts;
  double? averageRating;
  int? totalReviews;
  List<ReviewData>? reviews;

  String? bidIncrement;
  num? maxBidsPerUser;
  String? participantsInterestFee;
  String? startDate;
  String? endDate;
  String? auctionStatus;
  num? quantity;

  bool get isSoldOut => quantity != null && quantity! <= 0;

  dynamic admin;

  bool get isVerified{
    if(admin != null){
      return true;
    }
    if(vendor != null){
      return vendor?.isVerified ?? false;
    }
    if(store != null){
      return store?.isVerified ?? false;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['vendorId'] = vendorId;
    map['storeId'] = storeId;
    map['categoryId'] = categoryId;
    map['name'] = name;
    map['sku'] = sku;
    map['condition'] = condition;
    map['description'] = description;
    map['specification'] = specification;
    map['price'] = price;
    map['discount_price'] = discountPrice;
    map['image_url'] = imageUrl;
    map['additional_images'] = jsonEncode(additionalImages ?? []);
    map['warranty'] = warranty;
    map['return_policy'] = returnPolicy;
    map['seo_title'] = seoTitle;
    map['meta_description'] = metaDescription;
    map['keywords'] = keywords;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (vendor != null) {
      map['vendor'] = vendor?.toJson();
    }
    if (subCategory != null) {
      map['sub_category'] = subCategory?.toJson();
    }
    if (store != null) {
      map['store'] = store?.toJson();
    }
    if(recommendedProducts != null){
      map['recommendedProducts'] = recommendedProducts?.map((v) => v.toJson()).toList();
    }
    map['averageRating'] = averageRating;
    map['totalReviews'] = totalReviews;
    if(reviews != null){
      map['reviews'] = reviews?.map((v) => v.toJson()).toList();
    }

    map['bidIncrement'] = bidIncrement;
    map['maxBidsPerUser'] = maxBidsPerUser;
    map['participantsInterestFee'] = participantsInterestFee;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['auctionStatus'] = auctionStatus;
    map['admin'] = admin;
    map['quantity'] = quantity;
    return map;
  }
}

Store storeFromJson(String str) => Store.fromJson(json.decode(str));
String storeToJson(Store data) => json.encode(data.toJson());
class Store {
  Store({
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
      this.currency,});

  Store.fromJson(dynamic json) {
    id = json['id'];
    vendorId = json['vendorId'];
    currencyId = json['currencyId'];
    name = json['name'];
    location = json['location'] != null ? LocationModel.fromJson(json['location']) : null;
    businessHours = json['businessHours'] != null ? BusinessHoursModel.fromJson(json['businessHours']) : null;
    deliveryOptions = json['deliveryOptions'] != null ? (json['deliveryOptions'] as List).map((i) => DeliveryOptionsModel.fromJson(i)).toList() : null;
    tipsOnFinding = json['tipsOnFinding'];
    logo = json['logo'];
    isVerified = json['isVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;
  }
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
  String? createdAt;
  String? updatedAt;
  Currency? currency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['vendorId'] = vendorId;
    map['currencyId'] = currencyId;
    map['name'] = name;
    map['location'] = location?.toJson();
    map['businessHours'] = businessHours?.toJson();
    map['tipsOnFinding'] = tipsOnFinding;
    map['logo'] = logo;
    map['isVerified'] = isVerified;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (currency != null) {
      map['currency'] = currency?.toJson();
    }
    if(deliveryOptions != null){
      map['deliveryOptions'] = deliveryOptions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Currency currencyFromJson(String str) => Currency.fromJson(json.decode(str));
String currencyToJson(Currency data) => json.encode(data.toJson());
class Currency {
  Currency({
      this.symbol,});

  Currency.fromJson(dynamic json) {
    symbol = json['symbol'];
  }
  String? symbol;
Currency copyWith({  String? symbol,
}) => Currency(  symbol: symbol ?? this.symbol,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['symbol'] = symbol;
    return map;
  }

}

SubCategory subCategoryFromJson(String str) => SubCategory.fromJson(json.decode(str));
String subCategoryToJson(SubCategory data) => json.encode(data.toJson());
class SubCategory {
  SubCategory({
      this.id, 
      this.name,});

  SubCategory.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
SubCategory copyWith({  String? id,
  String? name,
}) => SubCategory(  id: id ?? this.id,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

Vendor vendorFromJson(String str) => Vendor.fromJson(json.decode(str));
String vendorToJson(Vendor data) => json.encode(data.toJson());
class Vendor {
  Vendor({
      this.isVerified, 
      this.id, 
      this.firstName, 
      this.lastName, 
      this.gender, 
      this.email, 
      this.emailVerifiedAt, 
      this.phoneNumber, 
      this.dateOfBirth, 
      this.location, 
      this.photo, 
      this.wallet, 
      this.facebookId, 
      this.googleId, 
      this.accountType, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  Vendor.fromJson(dynamic json) {
    isVerified = json['isVerified'];
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phoneNumber = json['phoneNumber'];
    dateOfBirth = json['dateOfBirth'];
    photo = json['photo'];
    wallet = json['wallet'];
    facebookId = json['facebookId'];
    googleId = json['googleId'];
    accountType = json['accountType'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    try{
      if(json['location'] is List){
        var locationData = json['location'] as List;
        if(locationData.isNotEmpty){
          location = LocationModel.fromJson(locationData.first);
        }
      }else{
        location = json['location'] != null ? LocationModel.fromJson(json['location']) : null;
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }
  bool? isVerified;
  String? id;
  String? firstName;
  String? lastName;
  String? gender;
  String? email;
  String? emailVerifiedAt;
  String? phoneNumber;
  String? dateOfBirth;
  LocationModel? location;
  String? photo;
  dynamic wallet;
  dynamic facebookId;
  dynamic googleId;
  String? accountType;
  String? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isVerified'] = isVerified;
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['gender'] = gender;
    map['email'] = email;
    map['email_verified_at'] = emailVerifiedAt;
    map['phoneNumber'] = phoneNumber;
    map['dateOfBirth'] = dateOfBirth;
    map['location'] = location?.toJson();
    map['photo'] = photo;
    map['wallet'] = wallet;
    map['facebookId'] = facebookId;
    map['googleId'] = googleId;
    map['accountType'] = accountType;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}