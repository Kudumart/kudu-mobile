import 'dart:convert';

IdVerificationModel idVerificationModelFromJson(String str) =>
    IdVerificationModel.fromJson(json.decode(str));
String idVerificationModelToJson(IdVerificationModel data) =>
    json.encode(data.toJson());

class IdVerificationModel {
  IdVerificationModel({
    this.name,
    this.number,
    this.expiryDate,
  });

  IdVerificationModel.fromJson(dynamic json) {
    name = json['name'];
    number = json['number'];
    expiryDate = json['expiryDate'];
  }
  String? name;
  String? number;
  String? expiryDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['number'] = number;
    map['expiryDate'] = expiryDate;
    return map;
  }
}
