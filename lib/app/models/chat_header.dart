import 'package:equatable/equatable.dart';
import 'package:kudu/app/models/chat_counterpart.dart';
import 'package:kudu/app/models/chat_message.dart';

class ChatHeader extends Equatable {
  final String chatID;
  final int unreadMessagesCount;
  final ChatCounterpart counterpart;
  final String productName;
  final String productID;
  final ChatMessage lastMessage;

  const ChatHeader(
      {required this.chatID,
      required this.unreadMessagesCount,
      required this.counterpart,
      required this.productName,
      required this.productID,
      required this.lastMessage});

  ChatHeader.fromJson(Map<String, dynamic> json)
      : chatID = json["conversationId"] ?? "Default-chatID",
        unreadMessagesCount = json["unreadMessagesCount"] ?? -1,
        productName = json["product"]["name"] ?? "Default-product-name",
        counterpart = ChatCounterpart.fromJson(json["senderUser"]),
        productID = json["product"]['id'] ?? "Default-product-id",
        lastMessage =
            ChatMessage.fromJson((json["message"] as List<dynamic>?)?[0]);

  @override
  List<Object?> get props =>
      [chatID, unreadMessagesCount, counterpart, lastMessage];
}
