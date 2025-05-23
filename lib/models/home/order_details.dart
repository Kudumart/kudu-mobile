import 'dart:convert';

import 'package:kudu/models/home/products_list_model.dart';
OrderDetails orderDetailsFromJson(String str) => OrderDetails.fromJson(json.decode(str));
String orderDetailsToJson(OrderDetails data) => json.encode(data.toJson());
class OrderDetails {
  OrderDetails({
      this.message, 
      this.data, 
      this.meta,
  });

  OrderDetails.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OrderDetail.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  String? message;
  List<OrderDetail>? data;
  Meta? meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    return map;
  }

}

Meta metaFromJson(String str) => Meta.fromJson(json.decode(str));
String metaToJson(Meta data) => json.encode(data.toJson());
class Meta {
  Meta({
      this.total, 
      this.page, 
      this.limit, 
      this.totalPages,});

  Meta.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }
  num? total;
  num? page;
  num? limit;
  num? totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    return map;
  }

}

OrderDetail dataFromJson(String str) => OrderDetail.fromJson(json.decode(str));
String dataToJson(OrderDetail data) => json.encode(data.toJson());
class OrderDetail {
  OrderDetail({
      this.product, 
      this.id, 
      this.vendorId, 
      this.orderId, 
      this.quantity, 
      this.price, 
      this.status, 
      this.createdAt, 
      this.updatedAt,
  });

  OrderDetail.fromJson(dynamic json) {
    product = json['product'] != null ? ProductData.fromJson(json['product']) : null;
    id = json['id'];
    vendorId = json['vendorId'];
    orderId = json['orderId'];
    quantity = json['quantity'];
    price = json['price'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  ProductData? product;
  String? id;
  String? vendorId;
  String? orderId;
  num? quantity;
  String? price;
  String? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (product != null) {
      map['product'] = product?.toJson();
    }
    map['id'] = id;
    map['vendorId'] = vendorId;
    map['orderId'] = orderId;
    map['quantity'] = quantity;
    map['price'] = price;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}