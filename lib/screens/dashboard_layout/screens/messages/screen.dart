import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/models/chat_counterpart.dart';
import 'package:kudu/models/chat_header.dart';
import 'package:kudu/models/chat_message.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/shared_widgets/avatar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../core/colors.dart';
import '../../../../core/constants.dart';
import '../../../../core/images.dart';

part 'widgets/search_bar.dart';
part 'widgets/chat_header_card.dart';
part 'widgets/unread_messages_count_view.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _totalUnreadMessagesCount = 0;

  final List<ChatHeader> _messageHeaders = List.generate(
      10,
      (_) => ChatHeader(
        productID: "55d867f8-0b51-4232-a863",
          chatID: "55d867f8-0b51-4232-a863-499698120c96",
          counterpart: ChatCounterpart.fromJson(const {
            "id": "d76398b3-6c76-429d-a404-45d065f10916",
            "firstName": "John",
            "lastName": "Doe",
            "email": "testuser@example.com",
            "phoneNumber": "+2349025181126"
          }),
          productName: "Greenmouse blue Sneakers",
          unreadMessagesCount: 5,
          lastMessage: ChatMessage.fromJson(const {
            "id": "af2dbfc9-0dc3-40f3-bad1-dd4632563704",
            "content":
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sed orci sed ante.",
            "fileUrl": "https://sequelize.org/docs/v6/other-topics/migrations/",
            "createdAt": "2024-12-02T11:28:44.000Z",
            "isRead": false
          })));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            bottom: const _SearchBar(),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14))),
            backgroundColor: AppUiColor.primary,
          ),
          body: SafeArea(
              child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // tab bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: UiConstant.horizontalPadding),
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicatorWeight: 3,
                      indicator: MaterialIndicator(
                        color: AppUiColor.primary,
                      ),
                      tabs: [
                        const Tab(text: "All"),
                        Tab(
                          text:
                              _totalUnreadMessagesCount == 0 ? "Unread" : null,
                          child: _totalUnreadMessagesCount > 0
                              ? Row(
                                  children: [
                                    const Text("Unread"),
                                    const SizedBox(width: 8),
                                    _UnreadMessagesCountView(
                                        _totalUnreadMessagesCount)
                                  ],
                                )
                              : null,
                        ),
                        const Tab(
                          text: "Read",
                        )
                      ]),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                        UiConstant.horizontalPadding,
                        20,
                        UiConstant.horizontalPadding,
                        0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18)),
                        color: AppUiColor.ghostWhite),
                    child: TabBarView(children: [
                      ListView.builder(
                          itemCount: _messageHeaders.length,
                          itemBuilder: (_, index) =>
                              _ChatHeaderCard(_messageHeaders[index])),
                      ListView.builder(
                          itemCount: _messageHeaders.length,
                          itemBuilder: (_, index) =>
                              _ChatHeaderCard(_messageHeaders[index])),
                      ListView.builder(
                          itemCount: _messageHeaders.length,
                          itemBuilder: (_, index) =>
                              _ChatHeaderCard(_messageHeaders[index])),
                    ]),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}
