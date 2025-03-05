import 'dart:convert';
DeliveryOptionsModel deliveryOptionsModelFromJson(String str) => DeliveryOptionsModel.fromJson(json.decode(str));
String deliveryOptionsModelToJson(DeliveryOptionsModel data) => json.encode(data.toJson());

class DeliveryOptionsModel {
  DeliveryOptionsModel({
      this.city, 
      this.price, 
      this.arrivalDay,});

  DeliveryOptionsModel.fromJson(dynamic json) {
    city = json['city'];
    price = json['price'];
    arrivalDay = json['arrival_day'];
  }
  String? city;
  num? price;
  String? arrivalDay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['city'] = city;
    map['price'] = price;
    map['arrival_day'] = arrivalDay;
    return map;
  }

}