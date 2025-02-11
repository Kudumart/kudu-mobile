import 'dart:convert';
MessageListResponse messageListResponseFromJson(String str) => MessageListResponse.fromJson(json.decode(str));
String messageListResponseToJson(MessageListResponse data) => json.encode(data.toJson());

class MessageListResponse {
  MessageListResponse({
      this.data,});

  MessageListResponse.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Data? data;
MessageListResponse copyWith({  Data? data,
}) => MessageListResponse(  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
      this.productId, 
      this.senderId, 
      this.receiverId, 
      this.createdAt, 
      this.updatedAt, 
      this.message, 
      this.product,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    productId = json['productId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message?.add(Message.fromJson(v));
      });
    }
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }
  String? id;
  String? productId;
  String? senderId;
  String? receiverId;
  String? createdAt;
  String? updatedAt;
  List<Message>? message;
  Product? product;
Data copyWith({  String? id,
  String? productId,
  String? senderId,
  String? receiverId,
  String? createdAt,
  String? updatedAt,
  List<Message>? message,
  Product? product,
}) => Data(  id: id ?? this.id,
  productId: productId ?? this.productId,
  senderId: senderId ?? this.senderId,
  receiverId: receiverId ?? this.receiverId,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  message: message ?? this.message,
  product: product ?? this.product,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['productId'] = productId;
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (message != null) {
      map['message'] = message?.map((v) => v.toJson()).toList();
    }
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }

}

Product productFromJson(String str) => Product.fromJson(json.decode(str));
String productToJson(Product data) => json.encode(data.toJson());
class Product {
  Product({
      this.id, 
      this.name, 
      this.price,});

  Product.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }
  String? id;
  String? name;
  String? price;
Product copyWith({  String? id,
  String? name,
  String? price,
}) => Product(  id: id ?? this.id,
  name: name ?? this.name,
  price: price ?? this.price,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['price'] = price;
    return map;
  }

}

Message messageFromJson(String str) => Message.fromJson(json.decode(str));
String messageToJson(Message data) => json.encode(data.toJson());
class Message {
  Message({
      this.id, 
      this.userId, 
      this.content, 
      this.fileUrl, 
      this.isRead, 
      this.createdAt, 
      this.updatedAt, 
      this.conversationId, 
      this.user,});

  Message.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    content = json['content'];
    fileUrl = json['fileUrl'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    conversationId = json['conversationId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? id;
  String? userId;
  String? content;
  String? fileUrl;
  bool? isRead;
  String? createdAt;
  String? updatedAt;
  String? conversationId;
  User? user;
Message copyWith({  String? id,
  String? userId,
  String? content,
  String? fileUrl,
  bool? isRead,
  String? createdAt,
  String? updatedAt,
  String? conversationId,
  User? user,
}) => Message(  id: id ?? this.id,
  userId: userId ?? this.userId,
  content: content ?? this.content,
  fileUrl: fileUrl ?? this.fileUrl,
  isRead: isRead ?? this.isRead,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  conversationId: conversationId ?? this.conversationId,
  user: user ?? this.user,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['content'] = content;
    map['fileUrl'] = fileUrl;
    map['isRead'] = isRead;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['conversationId'] = conversationId;
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
User copyWith({  String? id,
  String? firstName,
  String? lastName,
  String? email,
}) => User(  id: id ?? this.id,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  email: email ?? this.email,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    return map;
  }

}