import 'dart:convert';

import 'package:kudu/models/home/products_list_model.dart';

import '../../app/models/user.dart';
CustomerOrderDetails customerOrderDetailsFromJson(String str) => CustomerOrderDetails.fromJson(json.decode(str));
String customerOrderDetailsToJson(CustomerOrderDetails data) => json.encode(data.toJson());

class CustomerOrderDetails {
  CustomerOrderDetails({
      this.message, 
      this.data,});

  CustomerOrderDetails.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CustomerOrder.fromJson(v));
      });
    }
  }
  String? message;
  List<CustomerOrder>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

CustomerOrder dataFromJson(String str) => CustomerOrder.fromJson(json.decode(str));
String dataToJson(CustomerOrder data) => json.encode(data.toJson());
class CustomerOrder {
  CustomerOrder({
      this.product, 
      this.id, 
      this.vendorId, 
      this.orderId, 
      this.quantity, 
      this.price, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.order,});

  CustomerOrder.fromJson(dynamic json) {
    product = json['product'] != null ? ProductData.fromJson(json['product']) : null;
    id = json['id'];
    vendorId = json['vendorId'];
    orderId = json['orderId'];
    quantity = json['quantity'];
    price = json['price'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
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
  Order? order;

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
    if (order != null) {
      map['order'] = order?.toJson();
    }
    return map;
  }

}

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
String orderToJson(Order data) => json.encode(data.toJson());
class Order {
  Order({
      this.id, 
      this.userId, 
      this.trackingNumber, 
      this.totalAmount, 
      this.shippingAddress, 
      this.refId, 
      this.createdAt, 
      this.updatedAt, 
      this.user,});

  Order.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    trackingNumber = json['trackingNumber'];
    totalAmount = json['totalAmount'];
    shippingAddress = json['shippingAddress'];
    refId = json['refId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? id;
  String? userId;
  String? trackingNumber;
  String? totalAmount;
  String? shippingAddress;
  String? refId;
  String? createdAt;
  String? updatedAt;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['trackingNumber'] = trackingNumber;
    map['totalAmount'] = totalAmount;
    map['shippingAddress'] = shippingAddress;
    map['refId'] = refId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}