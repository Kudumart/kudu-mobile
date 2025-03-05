import '../../models/enums_and_extensions.dart';

class UserProfile {
  String firstName;
  String lastName;
  String email;
   String? dateOfBirth;
   String? phoneNumber;
   String? avatarUrl;
   bool isVerified;
   UserType userType;

  UserProfile(
      {required this.firstName,
      required this.lastName,
      required this.email,
      this.isVerified = false,
      required this.userType,
      this.dateOfBirth,
      this.phoneNumber,
      this.avatarUrl});

  UserProfile.fromJson(Map<String, dynamic> json)
      : firstName = json["firstName"],
        lastName = json["lastName"],
        email = json["email"],
        userType = userTypeFromString(json["userType"]),
        isVerified = json["isVerified"],
        dateOfBirth = json['dateOfBirth'],
        avatarUrl = json["photo"],
        phoneNumber = json["phoneNumber"];

  UserProfile copyWith(
      {String? firstName,
      String? lastName,
      String? email,
      bool? isVerified,
      String? dateOfBirth,
      String? phoneNumber,
      String? avatarUrl}) {
    return UserProfile(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        userType: userType,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        isVerified: isVerified ?? this.isVerified,
        avatarUrl: avatarUrl ?? this.avatarUrl);
  }
}
