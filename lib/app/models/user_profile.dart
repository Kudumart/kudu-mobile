class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String? avatarUrl;
  final bool isVerified;

  UserProfile(
      {required this.firstName,
      required this.lastName,
      required this.email,
      this.isVerified = false,
      this.dateOfBirth,
      this.phoneNumber,
      this.avatarUrl});

  UserProfile.fromJson(Map<String, dynamic> json)
      : firstName = json["firstName"],
        lastName = json["lastName"],
        email = json["email"],
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
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        isVerified: isVerified ?? this.isVerified,
        avatarUrl: avatarUrl ?? this.avatarUrl);
  }
}
