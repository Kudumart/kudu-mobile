import 'dart:developer';

import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String chatID;
  final String id;
  final String senderID;
  final String? content;
  final String? fileUrl;
  final bool isRead;
  final DateTime sent;
  const ChatMessage({
    required this.chatID,
    required this.senderID,
    required this.content,
    required this.id,
    required this.sent,
    this.isRead = false,
    this.fileUrl,
  });

  ChatMessage.fromJson(Map<String, dynamic> json)
      : chatID = json["conversationId"] ?? "Default-Chat-ID",
        id = json["id"] ?? "Default-Message-ID",
        senderID = json["userId"] ?? "Default-sender-id",
        content = json["content"],
        fileUrl = json["fileUrl"],
        sent = json.containsKey("createdAt")
            ? DateTime.parse(json["createdAt"] as String)
            : DateTime.now(),
        isRead = json["isRead"] ?? false;

  ChatMessage copyWith(
      {String? senderID,
      String? content,
      String? fileUrl,
      DateTime? sent,
      bool? isRead}) {
    return ChatMessage(
        chatID: chatID,
        senderID: senderID ?? this.senderID,
        content: content ?? this.content,
        id: id,
        sent: sent ?? this.sent,
        isRead: isRead ?? this.isRead);
  }

  static List<ChatMessage> fromList(List<dynamic> raw) {
    if (raw is! List<Map<String, dynamic>>) {
      log("Error: can not obtain chat message from non Map type ${raw.runtimeType}");
      return [];
    }

    return raw.map((element) => ChatMessage.fromJson(element)).toList();
  }

  bool sentByCurrentUser(String currentUserID) {
    return currentUserID == senderID;
  }

  @override
  List<Object?> get props => [chatID, id, isRead, senderID, content, fileUrl];
}
