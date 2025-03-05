import 'dart:convert';
BusinessHoursModel businessHoursModelFromJson(String str) => BusinessHoursModel.fromJson(json.decode(str));
String businessHoursModelToJson(BusinessHoursModel data) => json.encode(data.toJson());

class BusinessHoursModel {
  BusinessHoursModel({
      this.sunday, 
      this.saturday, 
      this.mondayFriday,});

  BusinessHoursModel.fromJson(dynamic json) {
    sunday = json['sunday'];
    saturday = json['saturday'];
    mondayFriday = json['monday_friday'];
  }
  String? sunday;
  String? saturday;
  String? mondayFriday;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sunday'] = sunday;
    map['saturday'] = saturday;
    map['monday_friday'] = mondayFriday;
    return map;
  }

}