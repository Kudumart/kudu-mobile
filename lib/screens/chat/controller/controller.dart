import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
//import 'package:kudu/app/data/api/client.dart';
import 'package:kudu/data/api/endpoints.dart';
import 'package:kudu/models/chat_message.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/screens/chat/controller/test_chat_api.dart';

part 'date_view.dart';
part 'chat_image_view.dart';
part 'chat_message_view.dart';

class ChatController extends ChangeNotifier {
  final String chatID;
  final Color currentUserMessageViewBubbleColor;
  final Color counterpartMessageViewBubbleColor;
  final TextStyle currentUserMessageTextstyle;
  final TextStyle counterpartMessageTextStyle;
  late final String _currentUserID;
  late final String _counterpartID;
  final List<Widget> _messages = [];
  late final Timer _pollingTimer;

  /// [_messageIDSet] contains id of messages that has been added to [_messages]
  final Map<String, bool> _messageIDSet = {};

  /// [lastMessageSentOn] is the date the last message was sent.
  DateTime _lastMessageSentOn = DateTime.now();
  String? _lastSenderID;
  Object? _error;

  ChatController(
      {required this.chatID,
      required this.currentUserMessageViewBubbleColor,
      required this.counterpartMessageViewBubbleColor,
      required this.counterpartMessageTextStyle,
      required this.currentUserMessageTextstyle});

  initialize() async {
    try {
      ChatTestApi.sendGetRequest(ApiEndpoint.chatMessages,
          authenticate: true,
          queryParameters: {"conversationId": chatID}).then((response) {
        if (response.body is! Map<String, dynamic>) {
          throw "Unexpected response body type on initialize chat controller ${response.body.runtimeType}";
        }
        final body = response.body as Map<String, dynamic>;
        _currentUserID = body["receiverId"];
        _counterpartID = body["senderId"];
        final rawMessage = body["message"];
        _initializeChatUiWithMessage(ChatMessage.fromList(rawMessage));
        notifyListeners();
      });
      _startPolling();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pollingTimer.cancel();
    super.dispose();
  }

  String get counterpartUserID => _counterpartID;
  String get currentUserID => _currentUserID;

  List<Widget> get messagesView => _messages;

  Future<void> _startPolling() async {
    _pollingTimer = Timer.periodic(const Duration(minutes: 1), _fetchMessages);
  }

  void _fetchMessages(Timer _) {
    try {
      ChatTestApi.sendGetRequest(ApiEndpoint.chatMessages,
          authenticate: true,
          queryParameters: {"conversationId": chatID}).then((response) {
        if (response.body is! Map<String, dynamic>) {
          throw "Unexpected response body type ${response.body.runtimeType}";
        }
        final body = response.body as Map<String, dynamic>;
        final rawMessage = body["message"];
        final newMessages = ChatMessage.fromList(rawMessage);
        for (var message in newMessages) {
          if (!_messageIDSet.containsKey(message.id)) {
            _addMessageToMessageViewList(message);
          }
        }
        notifyListeners();
      });
    } catch (e) {
      log("Error on poll chat messages: ${e.toString()}");
    }
  }

  /// [hasError] can only be true if any error is encountered on [initialize]
  bool get hasError => _error != null;

  void _initializeChatUiWithMessage(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return;
    }

    _addMessageToMessageViewList(messages[0]);

    for (int i = 1; i < messages.length; i++) {
      _addMessageToMessageViewList(messages[i],
          addTail: _addTail(messages: messages, currentIndex: i));
    }
  }

  bool _addTail(
      {required List<ChatMessage> messages, required int currentIndex}) {
    final previousIndex = currentIndex - 1;
    if (previousIndex <= 0) {
      return true; // first item
    }

    if (messages[previousIndex].senderID != messages[currentIndex].senderID) {
      return true;
    }

    final nextIndex = currentIndex + 1;
    if (nextIndex >= messages.length) {
      return true;
    }

    if (messages[currentIndex].senderID != messages[nextIndex].senderID) {
      return true;
    }

    return false;
  }

  void _addMessageToMessageViewList(ChatMessage message,
      {bool addTail = false}) {
    if (!message.sent.isSameDayAs(_lastMessageSentOn)) {
      messagesView.add(_DateChip(date: message.sent));

      _lastMessageSentOn = message.sent;
    }

    // add space if last sender is different from this sender
    if (_lastSenderID != message.senderID) {
      messagesView.add(const SizedBox(height: 25));
      addTail = true;
    }

    if (message.content != null) {
      messagesView.add(_convertChatMessageToView(message, addTail: addTail));
    }
    if (message.fileUrl != null) {
      messagesView
          .add(_convertChatMessageToImageView(message, addTail: addTail));
    }
    _messageIDSet[message.id] = true;
    _lastSenderID = message.senderID;
  }

  Widget _convertChatMessageToView(ChatMessage message,
      {required bool addTail}) {
    return _ChatMessageView(
      key: Key(message.id),
      sent: message.sent,
      isSentByCurrentUser: message.sentByCurrentUser(currentUserID),
      text: message.content!,
      tail: addTail,
      color: message.sentByCurrentUser(currentUserID)
          ? currentUserMessageViewBubbleColor
          : counterpartMessageViewBubbleColor,
      seen: message.isRead,
      textStyle: message.sentByCurrentUser(currentUserID)
          ? currentUserMessageTextstyle
          : counterpartMessageTextStyle,
    );
  }

  Widget _convertChatMessageToImageView(ChatMessage message,
      {required bool addTail}) {
    return _ChatMessageImageView(
      key: Key(message.id),
      sent: message.sent,
      image: message.fileUrl!,
      tail: addTail,
      isSentByCurrentUser: message.sentByCurrentUser(currentUserID),
      color: message.sentByCurrentUser(currentUserID)
          ? currentUserMessageViewBubbleColor
          : counterpartMessageViewBubbleColor,
      seen: message.isRead,
    );
  }

  addCurrentUserMessage(ChatMessage message) {
    _addMessageToMessageViewList(message.copyWith(senderID: currentUserID));
    notifyListeners();
  }
}
