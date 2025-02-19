import 'dart:convert';
NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));
String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  NotificationsModel({
      this.data, 
      this.meta,});

  NotificationsModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(NotificationDataFromApi.fromJson(v));
      });
    }
    meta = json['meta'] != null ? NotificationMeta.fromJson(json['meta']) : null;
  }
  List<NotificationDataFromApi>? data;
  NotificationMeta? meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    return map;
  }

}

NotificationMeta metaFromJson(String str) => NotificationMeta.fromJson(json.decode(str));
String metaToJson(NotificationMeta data) => json.encode(data.toJson());
class NotificationMeta {
  NotificationMeta({
      this.total, 
      this.page, 
      this.limit, 
      this.totalPages,});

  NotificationMeta.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }
  num? total;
  num? page;
  num? limit;
  num? totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    return map;
  }

}

NotificationDataFromApi dataFromJson(String str) => NotificationDataFromApi.fromJson(json.decode(str));
String dataToJson(NotificationDataFromApi data) => json.encode(data.toJson());
class NotificationDataFromApi {
  NotificationDataFromApi({
      this.id, 
      this.userId, 
      this.title, 
      this.message, 
      this.type, 
      this.isRead, 
      this.createdAt, 
      this.updatedAt,});

  NotificationDataFromApi.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? title;
  String? message;
  String? type;
  bool? isRead;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['title'] = title;
    map['message'] = message;
    map['type'] = type;
    map['isRead'] = isRead;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}