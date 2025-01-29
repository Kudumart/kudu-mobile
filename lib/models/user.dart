// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserData? data;

  UserModel({
    this.data,
  });

  UserModel copyWith({
    UserData? data,
  }) =>
      UserModel(
        data: data ?? this.data,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class UserData {
  bool? isVerified;
  String? id;
  String? firstName;
  String? lastName;
  dynamic gender;
  String? email;
  DateTime? emailVerifiedAt;
  String? phoneNumber;
  dynamic dateOfBirth;
  dynamic location;
  dynamic photo;
  dynamic wallet;
  dynamic facebookId;
  dynamic googleId;
  String? accountType;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserData({
    this.isVerified,
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.emailVerifiedAt,
    this.phoneNumber,
    this.dateOfBirth,
    this.location,
    this.photo,
    this.wallet,
    this.facebookId,
    this.googleId,
    this.accountType,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  UserData copyWith({
    bool? isVerified,
    String? id,
    String? firstName,
    String? lastName,
    dynamic gender,
    String? email,
    DateTime? emailVerifiedAt,
    String? phoneNumber,
    dynamic dateOfBirth,
    dynamic location,
    dynamic photo,
    dynamic wallet,
    dynamic facebookId,
    dynamic googleId,
    String? accountType,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UserData(
        isVerified: isVerified ?? this.isVerified,
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        gender: gender ?? this.gender,
        email: email ?? this.email,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        location: location ?? this.location,
        photo: photo ?? this.photo,
        wallet: wallet ?? this.wallet,
        facebookId: facebookId ?? this.facebookId,
        googleId: googleId ?? this.googleId,
        accountType: accountType ?? this.accountType,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        isVerified: json["isVerified"],
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        gender: json["gender"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        phoneNumber: json["phoneNumber"],
        dateOfBirth: json["dateOfBirth"],
        location: json["location"],
        photo: json["photo"],
        wallet: json["wallet"],
        facebookId: json["facebookId"],
        googleId: json["googleId"],
        accountType: json["accountType"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "isVerified": isVerified,
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "phoneNumber": phoneNumber,
        "dateOfBirth": dateOfBirth,
        "location": location,
        "photo": photo,
        "wallet": wallet,
        "facebookId": facebookId,
        "googleId": googleId,
        "accountType": accountType,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
