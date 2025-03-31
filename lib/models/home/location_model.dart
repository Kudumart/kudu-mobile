import 'dart:convert';
LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));
String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
      this.city, 
      this.state, 
      this.address, 
      this.country,});

  LocationModel.fromJson(dynamic json) {
    city = json['city'];
    state = json['state'];
    address = json['address'];
    country = json['country'];
  }
  String? city;
  String? state;
  String? address;
  String? country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['city'] = city;
    map['state'] = state;
    map['address'] = address;
    map['country'] = country;
    return map;
  }

  LocationModel copyWith({
    String? city,
    String? state,
    String? address,
    String? country,
  }) {
    return LocationModel(
      city: city ?? this.city,
      state: state ?? this.state,
      address: address ?? this.address,
      country: country ?? this.country,
    );
  }
}