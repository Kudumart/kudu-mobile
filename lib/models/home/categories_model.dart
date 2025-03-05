import 'dart:convert';
CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));
String categoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
  CategoriesModel({
      this.data,});

  CategoriesModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  List<Data>? data;
CategoriesModel copyWith({  List<Data>? data,
}) => CategoriesModel(  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
      this.image, 
      this.name, 
      this.createdAt, 
      this.updatedAt, 
      this.subCategories,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['subCategories'] != null) {
      subCategories = [];
      json['subCategories'].forEach((v) {
        subCategories?.add(SubCategories.fromJson(v));
      });
    }
  }
  String? id;
  String? image;
  String? name;
  String? createdAt;
  String? updatedAt;
  List<SubCategories>? subCategories;
Data copyWith({  String? id,
  String? image,
  String? name,
  String? createdAt,
  String? updatedAt,
  List<SubCategories>? subCategories,
}) => Data(  id: id ?? this.id,
  image: image ?? this.image,
  name: name ?? this.name,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  subCategories: subCategories ?? this.subCategories,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    map['name'] = name;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (subCategories != null) {
      map['subCategories'] = subCategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

SubCategories subCategoriesFromJson(String str) => SubCategories.fromJson(json.decode(str));
String subCategoriesToJson(SubCategories data) => json.encode(data.toJson());
class SubCategories {
  SubCategories({
      this.id, 
      this.categoryId, 
      this.image, 
      this.name, 
      this.createdAt, 
      this.updatedAt,});

  SubCategories.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['categoryId'];
    image = json['image'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? categoryId;
  String? image;
  String? name;
  String? createdAt;
  String? updatedAt;
SubCategories copyWith({  String? id,
  String? categoryId,
  String? image,
  String? name,
  String? createdAt,
  String? updatedAt,
}) => SubCategories(  id: id ?? this.id,
  categoryId: categoryId ?? this.categoryId,
  image: image ?? this.image,
  name: name ?? this.name,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['categoryId'] = categoryId;
    map['image'] = image;
    map['name'] = name;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}