import 'dart:convert';
DeliveryOptionsModel deliveryOptionsModelFromJson(String str) => DeliveryOptionsModel.fromJson(json.decode(str));
String deliveryOptionsModelToJson(DeliveryOptionsModel data) => json.encode(data.toJson());

class DeliveryOptionsModel {
  DeliveryOptionsModel({
      this.city, 
      this.price, 
      this.arrivalDay,
      this.scope,
      this.state,
      this.stateCode,
      this.country,
      this.countryCode,});

  DeliveryOptionsModel.fromJson(dynamic json) {
    city = json['city'];
    price = json['price'] is String ? num.tryParse(json['price']) : json['price'];
    arrivalDay = json['arrival_day'];
    scope = json['scope'];
    state = json['state'];
    stateCode = json['stateCode'];
    country = json['country'];
    countryCode = json['countryCode'];
  }
  String? city;
  num? price;
  String? arrivalDay;
  /// Coverage level: 'city', 'state' or 'country'.
  String? scope;
  String? state;
  String? stateCode;
  String? country;
  String? countryCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['city'] = city;
    map['price'] = price;
    map['arrival_day'] = arrivalDay;
    if (scope != null) map['scope'] = scope;
    if (state != null) map['state'] = state;
    if (stateCode != null) map['stateCode'] = stateCode;
    if (country != null) map['country'] = country;
    if (countryCode != null) map['countryCode'] = countryCode;
    return map;
  }

}
