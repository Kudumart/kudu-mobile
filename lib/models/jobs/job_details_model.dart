import 'dart:convert';
JobDetailsModel jobDetailsModelFromJson(String str) => JobDetailsModel.fromJson(json.decode(str));
String jobDetailsModelToJson(JobDetailsModel data) => json.encode(data.toJson());

class JobDetailsModel {
  JobDetailsModel({
      this.id, 
      this.creatorId, 
      this.title, 
      this.slug, 
      this.company, 
      this.logo, 
      this.workplaceType, 
      this.location, 
      this.jobType, 
      this.description, 
      this.views, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  JobDetailsModel.fromJson(dynamic json) {
    id = json['id'];
    creatorId = json['creatorId'];
    title = json['title'];
    slug = json['slug'];
    company = json['company'];
    logo = json['logo'];
    workplaceType = json['workplaceType'];
    location = json['location'];
    jobType = json['jobType'];
    description = json['description'];
    views = json['views'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? creatorId;
  String? title;
  String? slug;
  dynamic company;
  dynamic logo;
  String? workplaceType;
  String? location;
  String? jobType;
  String? description;
  num? views;
  String? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creatorId'] = creatorId;
    map['title'] = title;
    map['slug'] = slug;
    map['company'] = company;
    map['logo'] = logo;
    map['workplaceType'] = workplaceType;
    map['location'] = location;
    map['jobType'] = jobType;
    map['description'] = description;
    map['views'] = views;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}