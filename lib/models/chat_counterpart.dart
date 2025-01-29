import 'package:equatable/equatable.dart';

class ChatCounterpart extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final String phoneNumber;

  const ChatCounterpart({required this.id, required this.phoneNumber, required this.name, this.avatarUrl});
  
  ChatCounterpart.fromJson(Map<String, dynamic> json):
    id = json["id"] ?? "Default-ID",
    name = "${json["firstName"] ?? "FirstName"} ${json["lastName"] ?? "LastName"}",
    avatarUrl = json["avatar"],
    phoneNumber = json["phoneNumber"] ?? "Default-PhoneNumber";

  @override
  List<Object?> get props => [id, name, avatarUrl, phoneNumber];
}