// To parse this JSON data, do
//
//     final getKycModel = getKycModelFromJson(jsonString);

import 'dart:convert';

GetKycModel getKycModelFromJson(String str) =>
    GetKycModel.fromJson(json.decode(str));

String getKycModelToJson(GetKycModel data) => json.encode(data.toJson());

class GetKycModel {
  Data? data;

  GetKycModel({
    this.data,
  });

  GetKycModel copyWith({
    Data? data,
  }) =>
      GetKycModel(
        data: data ?? this.data,
      );

  factory GetKycModel.fromJson(Map<String, dynamic> json) => GetKycModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  String? id;
  String? vendorId;
  String? businessName;
  String? contactEmail;
  String? contactPhoneNumber;
  String? businessDescription;
  String? businessLink;
  String? businessAddress;
  String? businessRegistrationNumber;
  String? idVerification;
  dynamic adminNote;
  bool? isVerified;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.vendorId,
    this.businessName,
    this.contactEmail,
    this.contactPhoneNumber,
    this.businessDescription,
    this.businessLink,
    this.businessAddress,
    this.businessRegistrationNumber,
    this.idVerification,
    this.adminNote,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  Data copyWith({
    String? id,
    String? vendorId,
    String? businessName,
    String? contactEmail,
    String? contactPhoneNumber,
    String? businessDescription,
    String? businessLink,
    String? businessAddress,
    String? businessRegistrationNumber,
    String? idVerification,
    dynamic adminNote,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Data(
        id: id ?? this.id,
        vendorId: vendorId ?? this.vendorId,
        businessName: businessName ?? this.businessName,
        contactEmail: contactEmail ?? this.contactEmail,
        contactPhoneNumber: contactPhoneNumber ?? this.contactPhoneNumber,
        businessDescription: businessDescription ?? this.businessDescription,
        businessLink: businessLink ?? this.businessLink,
        businessAddress: businessAddress ?? this.businessAddress,
        businessRegistrationNumber:
            businessRegistrationNumber ?? this.businessRegistrationNumber,
        idVerification: idVerification ?? this.idVerification,
        adminNote: adminNote ?? this.adminNote,
        isVerified: isVerified ?? this.isVerified,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        vendorId: json["vendorId"],
        businessName: json["businessName"],
        contactEmail: json["contactEmail"],
        contactPhoneNumber: json["contactPhoneNumber"],
        businessDescription: json["businessDescription"],
        businessLink: json["businessLink"],
        businessAddress: json["businessAddress"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
        idVerification: json["idVerification"],
        adminNote: json["adminNote"],
        isVerified: json["isVerified"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendorId": vendorId,
        "businessName": businessName,
        "contactEmail": contactEmail,
        "contactPhoneNumber": contactPhoneNumber,
        "businessDescription": businessDescription,
        "businessLink": businessLink,
        "businessAddress": businessAddress,
        "businessRegistrationNumber": businessRegistrationNumber,
        "idVerification": idVerification,
        "adminNote": adminNote,
        "isVerified": isVerified,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
