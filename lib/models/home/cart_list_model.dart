import 'dart:convert';

import 'package:kudu/models/home/products_list_model.dart';
CartListModel cartListModelFromJson(String str) => CartListModel.fromJson(json.decode(str));
String cartListModelToJson(CartListModel data) => json.encode(data.toJson());
class CartListModel {
  CartListModel({
      this.data,});

  CartListModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CartData.fromJson(v));
      });
    }
  }
  List<CartData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

CartData dataFromJson(String str) => CartData.fromJson(json.decode(str));
String dataToJson(CartData data) => json.encode(data.toJson());
class CartData {
  CartData({
      this.id, 
      this.userId, 
      this.productId, 
      this.quantity, 
      this.createdAt, 
      this.updatedAt, 
      this.user, 
      this.product,});

  CartData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    productId = json['productId'];
    quantity = json['quantity'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    product = json['product'] != null ? ProductData.fromJson(json['product']) : null;
  }
  String? id;
  String? userId;
  String? productId;
  num? quantity;
  String? createdAt;
  String? updatedAt;
  User? user;
  ProductData? product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['productId'] = productId;
    map['quantity'] = quantity;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }

}

Store storeFromJson(String str) => Store.fromJson(json.decode(str));
String storeToJson(Store data) => json.encode(data.toJson());
class Store {
  Store({
      this.name, 
      this.currency,});

  Store.fromJson(dynamic json) {
    name = json['name'];
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;
  }
  String? name;
  Currency? currency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    if (currency != null) {
      map['currency'] = currency?.toJson();
    }
    return map;
  }

}

Currency currencyFromJson(String str) => Currency.fromJson(json.decode(str));
String currencyToJson(Currency data) => json.encode(data.toJson());
class Currency {
  Currency({
      this.name, 
      this.symbol,});

  Currency.fromJson(dynamic json) {
    name = json['name'];
    symbol = json['symbol'];
  }
  String? name;
  String? symbol;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['symbol'] = symbol;
    return map;
  }

}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      this.location, 
      this.isVerified, 
      this.id, 
      this.firstName, 
      this.lastName, 
      this.gender, 
      this.email, 
      this.emailVerifiedAt, 
      this.phoneNumber, 
      this.dateOfBirth, 
      this.photo, 
      this.wallet, 
      this.dollarWallet, 
      this.facebookId, 
      this.googleId, 
      this.accountType, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  User.fromJson(dynamic json) {
    location = json['location'];
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
    dollarWallet = json['dollarWallet'];
    facebookId = json['facebookId'];
    googleId = json['googleId'];
    accountType = json['accountType'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  dynamic location;
  bool? isVerified;
  String? id;
  String? firstName;
  String? lastName;
  dynamic gender;
  String? email;
  String? emailVerifiedAt;
  String? phoneNumber;
  dynamic dateOfBirth;
  dynamic photo;
  dynamic wallet;
  String? dollarWallet;
  dynamic facebookId;
  dynamic googleId;
  String? accountType;
  String? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location'] = location;
    map['isVerified'] = isVerified;
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['gender'] = gender;
    map['email'] = email;
    map['email_verified_at'] = emailVerifiedAt;
    map['phoneNumber'] = phoneNumber;
    map['dateOfBirth'] = dateOfBirth;
    map['photo'] = photo;
    map['wallet'] = wallet;
    map['dollarWallet'] = dollarWallet;
    map['facebookId'] = facebookId;
    map['googleId'] = googleId;
    map['accountType'] = accountType;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}