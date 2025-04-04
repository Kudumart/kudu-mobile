import 'dart:convert';
User user2FromJson(String str) => User.fromJson(json.decode(str));
String user2ToJson(User data) => json.encode(data.toJson());

class User {
  bool isVerified = false;
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";
  String? token;
  String? id;
  dynamic gender;
  String? email;
  String? emailVerifiedAt;
  String? password;
  dynamic dateOfBirth;
  dynamic location;
  dynamic photo;
  dynamic wallet;
  dynamic facebookId;
  dynamic googleId;
  String? accountType;
  String? status;
  String? createdAt;
  String? updatedAt;

  User({
    required this.isVerified,
    this.id,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.email,
    this.emailVerifiedAt,
    this.password,
    required this.phoneNumber,
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
    this.token,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isVerified'] = isVerified;
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['gender'] = gender;
    map['email'] = email;
    map['email_verified_at'] = emailVerifiedAt;
    map['password'] = password;
    map['phoneNumber'] = phoneNumber;
    map['dateOfBirth'] = dateOfBirth;
    map['location'] = location;
    map['photo'] = photo;
    map['wallet'] = wallet;
    map['facebookId'] = facebookId;
    map['googleId'] = googleId;
    map['accountType'] = accountType;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['token'] = token;
    return map;
  }

  User.fromJson(dynamic json) {
    isVerified = json['isVerified'] ?? false;
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    dateOfBirth = json['dateOfBirth'];
    location = json['location'];
    photo = json['photo'];
    wallet = json['wallet'];
    facebookId = json['facebookId'];
    googleId = json['googleId'];
    accountType = json['accountType'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    token = json['token'];
  }

  User copyWith({bool? isVerified,
    String? id,
    String? firstName,
    String? lastName,
    dynamic gender,
    String? email,
    String? emailVerifiedAt,
    String? password,
    String? phoneNumber,
    dynamic dateOfBirth,
    dynamic location,
    dynamic photo,
    dynamic wallet,
    dynamic facebookId,
    dynamic googleId,
    String? accountType,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? token,
  }) => User(isVerified: isVerified ?? this.isVerified,
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    gender: gender ?? this.gender,
    email: email ?? this.email,
    emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    password: password ?? this.password,
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
    token: token ?? this.token,
  );
}