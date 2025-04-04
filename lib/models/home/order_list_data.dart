import 'dart:convert';
OrderListData orderListDataFromJson(String str) => OrderListData.fromJson(json.decode(str));
String orderListDataToJson(OrderListData data) => json.encode(data.toJson());
class OrderListData {
  OrderListData({
      this.message, 
      this.data,
  });

  OrderListData.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  String? message;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.userId, 
      this.trackingNumber, 
      this.totalAmount, 
      this.shippingAddress, 
      this.refId, 
      this.createdAt, 
      this.updatedAt, 
      this.orderItemsCount,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    trackingNumber = json['trackingNumber'];
    totalAmount = json['totalAmount'];
    shippingAddress = json['shippingAddress'];
    refId = json['refId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderItemsCount = json['orderItemsCount'];
  }
  String? id;
  String? userId;
  String? trackingNumber;
  String? totalAmount;
  String? shippingAddress;
  String? refId;
  String? createdAt;
  String? updatedAt;
  num? orderItemsCount;

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
    map['orderItemsCount'] = orderItemsCount;
    return map;
  }

}