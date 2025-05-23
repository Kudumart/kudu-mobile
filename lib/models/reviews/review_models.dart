import 'dart:convert';
ReviewModels reviewModelsFromJson(String str) => ReviewModels.fromJson(json.decode(str));
String reviewModelsToJson(ReviewModels data) => json.encode(data.toJson());

class ReviewModels {
  ReviewModels({
      this.data,
  });

  ReviewModels.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ReviewData.fromJson(v));
      });
    }
  }
  List<ReviewData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

ReviewData dataFromJson(String str) => ReviewData.fromJson(json.decode(str));
String dataToJson(ReviewData data) => json.encode(data.toJson());
class ReviewData {
  ReviewData({
      this.id, 
      this.userId, 
      this.productId, 
      this.rating, 
      this.comment, 
      this.createdAt, 
      this.updatedAt, 
      this.user,});

  ReviewData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    productId = json['productId'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? id;
  String? userId;
  String? productId;
  num? rating;
  String? comment;
  String? createdAt;
  String? updatedAt;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['productId'] = productId;
    map['rating'] = rating;
    map['comment'] = comment;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.email,});

  User.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    return map;
  }

}