import 'dart:convert';
SendMessageResponse sendMessageResponseFromJson(String str) => SendMessageResponse.fromJson(json.decode(str));
String sendMessageResponseToJson(SendMessageResponse data) => json.encode(data.toJson());

class SendMessageResponse {
  SendMessageResponse({
      this.message, 
      this.data,});

  SendMessageResponse.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;
SendMessageResponse copyWith({  String? message,
  Data? data,
}) => SendMessageResponse(  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.isRead, 
      this.conversationId, 
      this.userId, 
      this.content, 
      this.fileUrl, 
      this.updatedAt, 
      this.createdAt,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    isRead = json['isRead'];
    conversationId = json['conversationId'];
    userId = json['userId'];
    content = json['content'];
    fileUrl = json['fileUrl'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }
  String? id;
  bool? isRead;
  String? conversationId;
  String? userId;
  String? content;
  String? fileUrl;
  String? updatedAt;
  String? createdAt;
Data copyWith({  String? id,
  bool? isRead,
  String? conversationId,
  String? userId,
  String? content,
  String? fileUrl,
  String? updatedAt,
  String? createdAt,
}) => Data(  id: id ?? this.id,
  isRead: isRead ?? this.isRead,
  conversationId: conversationId ?? this.conversationId,
  userId: userId ?? this.userId,
  content: content ?? this.content,
  fileUrl: fileUrl ?? this.fileUrl,
  updatedAt: updatedAt ?? this.updatedAt,
  createdAt: createdAt ?? this.createdAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['isRead'] = isRead;
    map['conversationId'] = conversationId;
    map['userId'] = userId;
    map['content'] = content;
    map['fileUrl'] = fileUrl;
    map['updatedAt'] = updatedAt;
    map['createdAt'] = createdAt;
    return map;
  }

}