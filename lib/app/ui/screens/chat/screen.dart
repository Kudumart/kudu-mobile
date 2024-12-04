import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/models/chat_message.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/constants.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/screens/chat/controller/controller.dart';
import 'package:kudu/app/ui/screens/chat/controller/test_chat_api.dart';
import 'package:kudu/app/ui/shared_widgets/avatar.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';
import 'package:kudu/app/ui/shared_widgets/overlay/overlay.dart';

import '../../../data/api/endpoints.dart';
import '../../../models/chat_header.dart';

part 'widgets/app_bar_title.dart';
part 'widgets/message_bar.dart';

class ChatScreen extends StatefulWidget {
  final ChatHeader chatHeader;
  const ChatScreen(this.chatHeader, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController _chatController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatController = ChatController(
      chatID: widget.chatHeader.chatID,
      counterpartMessageViewBubbleColor: Colors.white,
      currentUserMessageViewBubbleColor: AppUiColor.primary.withOpacity(0.1),
      counterpartMessageTextStyle:
          const TextStyle(fontSize: 12.5, color: Color(0xFF263238)),
      currentUserMessageTextstyle:
          const TextStyle(fontSize: 12.5, color: Color.fromARGB(255, 75, 67, 51)),
    );
    _chatController.initialize();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _chatController.addListener(_scrollToBottom);
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
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
              counterpartAvatarUrl: widget.chatHeader.counterpart.avatarUrl,
              counterpartName: widget.chatHeader.counterpart.name,
              productName: widget.chatHeader.productName,
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.ellipsis_vertical,
                      color: AppUiColor.iconBlack))
            ],
          ),
          body: SafeArea(
            minimum: EdgeInsets.fromLTRB(
                0, 10, 0, MediaQuery.viewInsetsOf(context).bottom),
            child: Column(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _chatController,
                    builder: (context, child) => ListView.builder(
                        controller: _scrollController,
                        itemCount: _chatController.messagesView.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: UiConstant.horizontalPadding),
                        itemBuilder: (_, index) {
                          return _chatController.messagesView[index];
                        }),
                  ),
                ),
                const SizedBox(height: 10),
                _MessageBar(onSend: _sendMessage)
              ],
            ),
          )),
    );
  }

  _sendMessage(String message) async {
    try {
      final json = {
        "content": message,
        "senderId": _chatController.currentUserID,
        "conversationId": widget.chatHeader.chatID,
        "receiverId": widget.chatHeader.counterpart.id,
        "productId": widget.chatHeader.productID,
        "isRead": false
      };
      _chatController.addCurrentUserMessage(ChatMessage.fromJson(json));
      await ChatTestApi.sendPostRequest(ApiEndpoint.chatMessages, json);
    } catch (e) {
      AppUiOverlay().showErrorSnackbarMessage(context, message: e.toString());
    }
  }
}
