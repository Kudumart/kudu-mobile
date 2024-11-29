class User {
  final bool isVerifed;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? token;

  User(
      {required this.isVerifed,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.token});

  User.fromJson(Map<String, dynamic> json)
      : isVerifed = json["isVerified"],
        firstName = json["firstName"],
        lastName = json["lastName"],
        phoneNumber = json["phoneNumber"],
        token = json["token"];
}
