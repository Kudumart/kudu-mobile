import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudu/models/chat_message.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/screens/chat/controller/controller.dart';
import 'package:kudu/screens/chat/controller/test_chat_api.dart';
import 'package:kudu/core/shared_widgets/avatar.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:provider/provider.dart';

import '../../data/api/endpoints.dart';
import '../../models/chat/conversation_list.dart' as conversation_list;
import '../../models/chat/message_list_response.dart';
import '../../models/chat_header.dart';
import '../../providers/chat_view_model.dart';

part 'widgets/app_bar_title.dart';
part 'widgets/message_bar.dart';

class ChatScreen extends StatefulWidget {
  final conversation_list.Data chatHeader;
  const ChatScreen(this.chatHeader, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatViewModel chatViewModel;
  MessageListResponse? messages;
  final ScrollController _scrollController = ScrollController();

  late Color currentUserMessageViewBubbleColor;
  late Color counterpartMessageViewBubbleColor;

  final Debouncer _debouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    chatViewModel= Provider.of<ChatViewModel>(context, listen: false);

    counterpartMessageViewBubbleColor = Colors.white;
    currentUserMessageViewBubbleColor = AppUiColor.primary.withOpacity(0.1);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getMessages();
      _scrollToBottom();
    });
  }

  Future<void> getMessages() async {
    var response = await chatViewModel.getMessages(conversationId: widget.chatHeader.id ?? "");
    if(mounted && response != null){
      messages = response;
      setState(() {});

      Future.delayed(const Duration(milliseconds: 500), () async {
        await getMessages();
      });

      markMessagesAsRead();
    }
  }

  Future<void> markMessagesAsRead() async {
    _debouncer.run(() async {
      await Future.forEach(messages?.data?.message ?? <Message>[], (message) async {
        if(message.isRead == false){
          if((message.id ?? "").isNotEmpty){
            await chatViewModel.markAsRead(messageId: message.id ?? "");
          }
        }
      });
      if(mounted){
        setState(() {});
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppUiColor.grey50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const AppBackButton(),
            titleSpacing: 0,
            centerTitle: false,
            title: _AppBarTitle(
              counterpartAvatarUrl: getUserAvatar,
              counterpartName: userDisplayName,
              productName: productName,
            ),
          ),
          body: ListView.builder(
              controller: _scrollController,
              itemCount: messages?.data?.message?.length ?? 0,
              //padding: const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
              itemBuilder: (_, index) {
                var currentMessage = messages?.data?.message?[index];
                var isSentByThisUser = isSentByCurrentUser(currentMessage?.user?.id ?? "");

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if((currentMessage?.fileUrl ?? "").isNotEmpty)...[
                      ChatMessageImageView(
                        isSentByCurrentUser: isSentByThisUser,
                        sent: (DateTime.tryParse(currentMessage?.createdAt ?? "") ?? DateTime.now()).toLocal(),
                        color: isSentByThisUser ? currentUserMessageViewBubbleColor : counterpartMessageViewBubbleColor,
                        seen: currentMessage?.isRead ?? false,
                        image: currentMessage?.fileUrl ?? "",
                      )
                    ],
                    ChatMessageView(
                      isSentByCurrentUser: isSentByThisUser,
                      text: currentMessage?.content ?? "",
                      sent: (DateTime.tryParse(currentMessage?.createdAt ?? "") ?? DateTime.now()).toLocal(),
                      color: isSentByThisUser ? currentUserMessageViewBubbleColor : counterpartMessageViewBubbleColor,
                      seen: currentMessage?.isRead ?? false,
                    ),
                  ],
                );
              },
          ),
          bottomNavigationBar:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: _MessageBar(
                  onSend: (message) async {
                    await chatViewModel.sendMessage(
                      receiverId: otherUserID,
                      productId: widget.chatHeader.productId ?? "",
                      message: message,
                    );
                  },
                  onSendWithFile: (message,file) async {
                    var fileUrl = await chatViewModel.uploadFile(file: file);
                    await chatViewModel.sendMessage(
                      receiverId: otherUserID,
                      productId: widget.chatHeader.productId ?? "",
                      message: message,
                      file: fileUrl,
                    );
                  },
                ),
              ),
            ],
          ),
      ),
    );
  }

  String get getUserAvatar{
    var currentUser = chatViewModel.userDataService.userData;
    if(currentUser?.id != widget.chatHeader.receiverId){
      return widget.chatHeader.receiverUser?.photo ?? "";
    }

    if(currentUser?.id != widget.chatHeader.senderId){
      return widget.chatHeader.senderUser?.photo ?? "";
    }
    return "";
  }

  String get userDisplayName{
    var currentUser = chatViewModel.userDataService.userData;
    if(currentUser?.id != widget.chatHeader.receiverId){
      return widget.chatHeader.receiverUser?.fullName ?? "";
    }

    if(currentUser?.id != widget.chatHeader.senderId){
      return widget.chatHeader.senderUser?.fullName ?? "";
    }
    return "";
  }

  String get otherUserID{
    var currentUser = chatViewModel.userDataService.userData;
    if(currentUser?.id != widget.chatHeader.receiverId){
      return widget.chatHeader.receiverId ?? "";
    }

    if(currentUser?.id != widget.chatHeader.senderId){
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
