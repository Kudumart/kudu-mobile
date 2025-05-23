import 'dart:convert';

import '../home/products_list_model.dart';
AdvertModel advertModelFromJson(String str) => AdvertModel.fromJson(json.decode(str));
String advertModelToJson(AdvertModel data) => json.encode(data.toJson());
class AdvertModel {
  AdvertModel({
      this.message, 
      this.data, 
      this.pagination,
  });

  AdvertModel.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(AdvertData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  String? message;
  List<AdvertData>? data;
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }

}

Pagination paginationFromJson(String str) => Pagination.fromJson(json.decode(str));
String paginationToJson(Pagination data) => json.encode(data.toJson());
class Pagination {
  Pagination({
      this.total, 
      this.page, 
      this.limit,});

  Pagination.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }
  num? total;
  num? page;
  num? limit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    return map;
  }

}

AdvertData dataFromJson(String str) => AdvertData.fromJson(json.decode(str));
String dataToJson(AdvertData data) => json.encode(data.toJson());
class AdvertData {
  AdvertData({
      this.id, 
      this.userId, 
      this.categoryId, 
      this.productId, 
      this.title, 
      this.description, 
      this.mediaUrl, 
      this.link, 
      this.clicks, 
      this.status, 
      this.adminNote, 
      this.showOnHomepage, 
      this.createdAt, 
      this.updatedAt, 
      this.vendor, 
      this.admin, 
      this.subCategory, 
      this.product,
  });

  AdvertData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    categoryId = json['categoryId'];
    productId = json['productId'];
    title = json['title'];
    description = json['description'];
    mediaUrl = json['media_url'];
    link = json['link'];
    clicks = json['clicks'];
    status = json['status'];
    adminNote = json['adminNote'];
    showOnHomepage = json['showOnHomepage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vendor = json['vendor'];
    admin = json['admin'] != null ? Admin.fromJson(json['admin']) : null;
    subCategory = json['sub_category'] != null ? SubCategory.fromJson(json['sub_category']) : null;
    product = json['product'] != null ? ProductData.fromJson(json['product']) : null;
  }
  String? id;
  String? userId;
  String? categoryId;
  dynamic productId;
  String? title;
  String? description;
  String? mediaUrl;
  String? link;
  num? clicks;
  String? status;
  dynamic adminNote;
  bool? showOnHomepage;
  String? createdAt;
  String? updatedAt;
  dynamic vendor;
  Admin? admin;
  SubCategory? subCategory;
  ProductData? product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['categoryId'] = categoryId;
    map['productId'] = productId;
    map['title'] = title;
    map['description'] = description;
    map['media_url'] = mediaUrl;
    map['link'] = link;
    map['clicks'] = clicks;
    map['status'] = status;
    map['adminNote'] = adminNote;
    map['showOnHomepage'] = showOnHomepage;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['vendor'] = vendor;
    if (admin != null) {
      map['admin'] = admin?.toJson();
    }
    if (subCategory != null) {
      map['sub_category'] = subCategory?.toJson();
    }
    map['product'] = product?.toJson();
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

Admin adminFromJson(String str) => Admin.fromJson(json.decode(str));
String adminToJson(Admin data) => json.encode(data.toJson());
class Admin {
  Admin({
      this.id, 
      this.name, 
      this.email,});

  Admin.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }
  String? id;
  String? name;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    return map;
  }

}