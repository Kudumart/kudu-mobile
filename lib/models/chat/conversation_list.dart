import 'dart:convert';
ConversationList conversationListFromJson(String str) => ConversationList.fromJson(json.decode(str));
String conversationListToJson(ConversationList data) => json.encode(data.toJson());

class ConversationList {
  ConversationList({
      this.message, 
      this.data,});

  ConversationList.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  String? message;
  List<Data>? data;
ConversationList copyWith({  String? message,
  List<Data>? data,
}) => ConversationList(  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
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
      this.productId, 
      this.senderId, 
      this.receiverId, 
      this.createdAt, 
      this.updatedAt, 
      this.unreadMessagesCount, 
      this.senderUser, 
      this.receiverUser, 
      this.product, 
      this.message,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    productId = json['productId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    unreadMessagesCount = json['unreadMessagesCount'];
    senderUser = json['senderUser'] != null ? SenderUser.fromJson(json['senderUser']) : null;
    receiverUser = json['receiverUser'] != null ? ReceiverUser.fromJson(json['receiverUser']) : null;
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message?.add(Message.fromJson(v));
      });
    }
  }
  String? id;
  String? productId;
  String? senderId;
  String? receiverId;
  String? createdAt;
  String? updatedAt;
  num? unreadMessagesCount;
  SenderUser? senderUser;
  ReceiverUser? receiverUser;
  Product? product;
  List<Message>? message;
Data copyWith({  String? id,
  String? productId,
  String? senderId,
  String? receiverId,
  String? createdAt,
  String? updatedAt,
  num? unreadMessagesCount,
  SenderUser? senderUser,
  ReceiverUser? receiverUser,
  Product? product,
  List<Message>? message,
}) => Data(  id: id ?? this.id,
  productId: productId ?? this.productId,
  senderId: senderId ?? this.senderId,
  receiverId: receiverId ?? this.receiverId,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
  senderUser: senderUser ?? this.senderUser,
  receiverUser: receiverUser ?? this.receiverUser,
  product: product ?? this.product,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['productId'] = productId;
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['unreadMessagesCount'] = unreadMessagesCount;
    if (senderUser != null) {
      map['senderUser'] = senderUser?.toJson();
    }
    if (receiverUser != null) {
      map['receiverUser'] = receiverUser?.toJson();
    }
    if (product != null) {
      map['product'] = product?.toJson();
    }
    if (message != null) {
      map['message'] = message?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Message messageFromJson(String str) => Message.fromJson(json.decode(str));
String messageToJson(Message data) => json.encode(data.toJson());
class Message {
  Message({
      this.id, 
      this.content, 
      this.fileUrl, 
      this.createdAt, 
      this.isRead,});

  Message.fromJson(dynamic json) {
    id = json['id'];
    content = json['content'];
    fileUrl = json['fileUrl'];
    createdAt = json['createdAt'];
    isRead = json['isRead'];
  }
  String? id;
  String? content;
  String? fileUrl;
  String? createdAt;
  bool? isRead;
Message copyWith({  String? id,
  String? content,
  String? fileUrl,
  String? createdAt,
  bool? isRead,
}) => Message(  id: id ?? this.id,
  content: content ?? this.content,
  fileUrl: fileUrl ?? this.fileUrl,
  createdAt: createdAt ?? this.createdAt,
  isRead: isRead ?? this.isRead,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['content'] = content;
    map['fileUrl'] = fileUrl;
    map['createdAt'] = createdAt;
    map['isRead'] = isRead;
    return map;
  }

}

Product productFromJson(String str) => Product.fromJson(json.decode(str));
String productToJson(Product data) => json.encode(data.toJson());
class Product {
  Product({
      this.id, 
      this.name,});

  Product.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
Product copyWith({  String? id,
  String? name,
}) => Product(  id: id ?? this.id,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

ReceiverUser receiverUserFromJson(String str) => ReceiverUser.fromJson(json.decode(str));
String receiverUserToJson(ReceiverUser data) => json.encode(data.toJson());
class ReceiverUser {
  ReceiverUser({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.phoneNumber, 
      this.photo,});

  ReceiverUser.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    photo = json['photo'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? photo;

  String? get fullName{
    if(firstName != null && lastName != null){
      return "$firstName $lastName";
    }
    if(firstName != null){
      return firstName;
    }
    if(lastName != null){
      return lastName;
    }
    return "";
  }

ReceiverUser copyWith({  String? id,
  String? firstName,
  String? lastName,
  String? email,
  String? phoneNumber,
  String? photo,
}) => ReceiverUser(  id: id ?? this.id,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  email: email ?? this.email,
  phoneNumber: phoneNumber ?? this.phoneNumber,
  photo: photo ?? this.photo,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['photo'] = photo;
    return map;
  }

}

SenderUser senderUserFromJson(String str) => SenderUser.fromJson(json.decode(str));
String senderUserToJson(SenderUser data) => json.encode(data.toJson());
class SenderUser {
  SenderUser({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.phoneNumber, 
      this.photo,});

  SenderUser.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    photo = json['photo'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? photo;

  String? get fullName{
    if(firstName != null && lastName != null){
      return "$firstName $lastName";
    }
    if(firstName != null){
      return firstName;
    }
    if(lastName != null){
      return lastName;
    }
    return "";
  }

SenderUser copyWith({  String? id,
  String? firstName,
  String? lastName,
  String? email,
  String? phoneNumber,
  String? photo,
}) => SenderUser(  id: id ?? this.id,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  email: email ?? this.email,
  phoneNumber: phoneNumber ?? this.phoneNumber,
  photo: photo ?? this.photo,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['photo'] = photo;
    return map;
  }

}