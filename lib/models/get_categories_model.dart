// To parse this JSON data, do
//
//     final getCategoriesModel = getCategoriesModelFromJson(jsonString);

import 'dart:convert';

GetCategoriesModel getCategoriesModelFromJson(String str) =>
    GetCategoriesModel.fromJson(json.decode(str));

String getCategoriesModelToJson(GetCategoriesModel data) =>
    json.encode(data.toJson());

class GetCategoriesModel {
  String? id;
  String? categoryId;
  String? image;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetCategoriesModel({
    this.id,
    this.categoryId,
    this.image,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  GetCategoriesModel copyWith({
    String? id,
    String? categoryId,
    String? image,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      GetCategoriesModel(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        image: image ?? this.image,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory GetCategoriesModel.fromJson(Map<String, dynamic> json) =>
      GetCategoriesModel(
        id: json["id"],
        categoryId: json["categoryId"],
        image: json["image"],
        name: json["name"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryId": categoryId,
        "image": image,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
