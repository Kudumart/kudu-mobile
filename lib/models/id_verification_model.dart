import 'dart:convert';
IdVerificationModel idVerificationModelFromJson(String str) => IdVerificationModel.fromJson(json.decode(str));
String idVerificationModelToJson(IdVerificationModel data) => json.encode(data.toJson());

class IdVerificationModel {
  IdVerificationModel({
      this.name, 
      this.number,});

  IdVerificationModel.fromJson(dynamic json) {
    name = json['name'];
    number = json['number'];
  }
  String? name;
  String? number;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['number'] = number;
    return map;
  }

}