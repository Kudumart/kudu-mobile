import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/screens/chat/controller/controller.dart';
import 'package:kudu/core/shared_widgets/avatar.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:provider/provider.dart';

import '../../models/chat/conversation_list.dart' as conversation_list;
import '../../models/chat/message_list_response.dart';
import '../../providers/chat_view_model.dart';

part 'widgets/app_bar_title.dart';
part 'widgets/message_bar.dart';

class ChatScreen extends StatefulWidget {
  final conversation_list.ConversationListData chatHeader;
  const ChatScreen(this.chatHeader, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? chatId;
  late ChatViewModel chatViewModel;
  List<Message> _messages = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  Timer? _pollingTimer;

  late Color currentUserMessageViewBubbleColor;
  late Color counterpartMessageViewBubbleColor;

  final Debouncer _debouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    chatViewModel = Provider.of<ChatViewModel>(context, listen: false);

    counterpartMessageViewBubbleColor = Colors.white;
    currentUserMessageViewBubbleColor = const Color(0xFFFFF7ED);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchMessages(showLoading: true);
      _scrollToBottom();
      _startPolling();
    });
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        _fetchMessages(showLoading: false);
      }
    });
  }

  Future<void> _fetchMessages({bool showLoading = false}) async {
    if (showLoading && _messages.isEmpty) {
      setState(() => _isLoading = true);
    }
    final conversationId = chatId ?? widget.chatHeader.id ?? "";
    if (conversationId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final response = await chatViewModel.getMessages(conversationId: conversationId);
    if (mounted && response != null) {
      final newMessages = response.data?.message ?? [];
      final hasChanged = newMessages.length != _messages.length ||
          (_messages.isNotEmpty && newMessages.isNotEmpty && newMessages.last.id != _messages.last.id);

      if (hasChanged || _isLoading) {
        setState(() {
          _messages = List.from(newMessages);
          _isLoading = false;
        });
        _scrollToBottom();
      }
      markMessagesAsRead();
    } else {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> markMessagesAsRead() async {
    _debouncer.run(() async {
      for (var message in _messages) {
        if (message.isRead == false && (message.id ?? "").isNotEmpty) {
          await chatViewModel.markAsRead(messageId: message.id ?? "");
        }
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSendMessage(String messageText) async {
    final trimmed = messageText.trim();
    if (trimmed.isEmpty) return;

    final currentUser = chatViewModel.userDataService.userData;
    final optimisticMessage = Message(
      id: "temp_${DateTime.now().millisecondsSinceEpoch}",
      content: trimmed,
      user: User(id: currentUser?.id, firstName: currentUser?.firstName, lastName: currentUser?.lastName),
      createdAt: DateTime.now().toIso8601String(),
      isRead: false,
    );

    setState(() {
      _messages.add(optimisticMessage);
    });
    _scrollToBottom();

    final response = await chatViewModel.sendMessage(
      receiverId: otherUserID,
      productId: widget.chatHeader.productId ?? "",
      message: trimmed,
    );

    if (response?.data?.conversationId != null) {
      chatId = response?.data?.conversationId;
    }
    _fetchMessages(showLoading: false);
  }

  void _onSendMessageWithFile(String messageText, File file) async {
    final trimmed = messageText.trim();
    final currentUser = chatViewModel.userDataService.userData;
    final optimisticMessage = Message(
      id: "temp_${DateTime.now().millisecondsSinceEpoch}",
      content: trimmed,
      fileUrl: file.path,
      user: User(id: currentUser?.id, firstName: currentUser?.firstName, lastName: currentUser?.lastName),
      createdAt: DateTime.now().toIso8601String(),
      isRead: false,
    );

    setState(() {
      _messages.add(optimisticMessage);
    });
    _scrollToBottom();

    final fileUrl = await chatViewModel.uploadFile(context: context, file: file);
    final response = await chatViewModel.sendMessage(
      receiverId: otherUserID,
      productId: widget.chatHeader.productId ?? "",
      message: trimmed,
      file: fileUrl,
    );

    if (response?.data?.conversationId != null) {
      chatId = response?.data?.conversationId;
    }
    _fetchMessages(showLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: const AppBackButton(),
          titleSpacing: 0,
          centerTitle: false,
          title: _AppBarTitle(
            counterpartAvatarUrl: getUserAvatar,
            counterpartName: userDisplayName,
            productName: productName,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _isLoading && _messages.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: AppUiColor.primary, strokeWidth: 2.5))
                  : _messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppUiColor.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chat_bubble_outline_rounded, size: 36, color: AppUiColor.primary),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "No messages yet",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Send a message below to start the conversation.",
                                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          itemCount: _messages.length,
                          itemBuilder: (_, index) {
                            var currentMessage = _messages[index];
                            var isSentByThisUser = isSentByCurrentUser(currentMessage.user?.id ?? "");

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if ((currentMessage.fileUrl ?? "").isNotEmpty) ...[
                                  ChatMessageImageView(
                                    isSentByCurrentUser: isSentByThisUser,
                                    sent: (DateTime.tryParse(currentMessage.createdAt ?? "") ?? DateTime.now()).toLocal(),
                                    color: isSentByThisUser ? currentUserMessageViewBubbleColor : counterpartMessageViewBubbleColor,
                                    seen: currentMessage.isRead ?? false,
                                    image: currentMessage.fileUrl ?? "",
                                  )
                                ],
                                ChatMessageView(
                                  isSentByCurrentUser: isSentByThisUser,
                                  text: currentMessage.content ?? "",
                                  sent: (DateTime.tryParse(currentMessage.createdAt ?? "") ?? DateTime.now()).toLocal(),
                                  color: isSentByThisUser ? currentUserMessageViewBubbleColor : counterpartMessageViewBubbleColor,
                                  seen: currentMessage.isRead ?? false,
                                ),
                              ],
                            );
                          },
                        ),
            ),
            _MessageBar(
              onSend: _onSendMessage,
              onSendWithFile: _onSendMessageWithFile,
            ),
          ],
        ),
      ),
    );
  }

  String get getUserAvatar{
    var currentUser = chatViewModel.userDataService.userData;
    if(currentUser?.id != widget.chatHeader.receiverId && widget.chatHeader.receiverId != null){
      return widget.chatHeader.receiverUser?.photo ?? "";
    }

    if(currentUser?.id != widget.chatHeader.senderId && widget.chatHeader.senderId != null){
      return widget.chatHeader.senderUser?.photo ?? "";
    }
    return "";
  }

  String get userDisplayName{
    var currentUser = chatViewModel.userDataService.userData;
    if(currentUser?.id != widget.chatHeader.receiverId && widget.chatHeader.receiverId != null){
      return widget.chatHeader.receiverUser?.fullName ?? "";
    }

    if(currentUser?.id != widget.chatHeader.senderId && widget.chatHeader.senderId != null){
      return widget.chatHeader.senderUser?.fullName ?? "";
    }
    return "";
  }

  String get otherUserID{
    var currentUser = chatViewModel.userDataService.userData;
    if(currentUser?.id != widget.chatHeader.receiverId && widget.chatHeader.receiverId != null){
      return widget.chatHeader.receiverId ?? "";
    }

    if(currentUser?.id != widget.chatHeader.senderId && widget.chatHeader.senderId != null){
      return widget.chatHeader.senderId ?? "";
    }
    return "";
  }

  int get unreadMessagesCount{
    return int.tryParse(widget.chatHeader.unreadMessagesCount?.toString() ?? "") ?? 0;
  }

  String get productName{
    return widget.chatHeader.product?.name ?? "";
  }

  String get lastMessageContent{
    return widget.chatHeader.message?.firstOrNull?.content ?? "";
  }

  bool isSentByCurrentUser(String userId){
    return chatViewModel.userDataService.userData?.id == userId;
  }
}
