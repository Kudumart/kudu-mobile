import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/models/chat_header.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../colors.dart';
import '../../../../constants.dart';
import '../../../../images.dart';

part 'widgets/search_bar.dart';
part 'widgets/message_header_card.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<MessageHeader> _messageHeaders = List.generate(
      10,
      (_) => MessageHeader(
          username: "Andrea Batoni",
          productName: "Pine wear T-shirts",
          lastMessageSnippet:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sed orci sed ante."));

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
                      tabs: const [
                        Tab(text: "All"),
                        Tab(
                          text: "Unread",
                        ),
                        Tab(
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
                              _MessageHeaderCard(_messageHeaders[index])),
                      ListView.builder(
                          itemCount: _messageHeaders.length,
                          itemBuilder: (_, index) =>
                              _MessageHeaderCard(_messageHeaders[index])),
                      ListView.builder(
                          itemCount: _messageHeaders.length,
                          itemBuilder: (_, index) =>
                              _MessageHeaderCard(_messageHeaders[index])),
                    ]),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}
