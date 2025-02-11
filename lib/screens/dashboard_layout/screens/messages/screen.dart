import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/models/chat/conversation_list.dart';
import 'package:kudu/models/chat_counterpart.dart';
import 'package:kudu/models/chat_header.dart';
import 'package:kudu/models/chat_message.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/core/shared_widgets/avatar.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../core/colors.dart';
import '../../../../core/constants.dart';
import '../../../../core/images.dart';
import '../../../../core/shared_widgets/overlay/overlay.dart';
import '../../../../providers/chat_view_model.dart';

part 'widgets/search_bar.dart';
part 'widgets/chat_header_card.dart';
part 'widgets/unread_messages_count_view.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  ConversationList? conversations;
  String searchQuery = "";
  var debouncer = Debouncer(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getConversations();
    });
  }

  Future<void> getConversations({bool load = true}) async {
    if(load){
      AppUiOverlay.showLoadingIndicator(context);
    }
    final model = Provider.of<ChatViewModel>(context, listen: false);
    conversations = await model.getConversations();
    AppUiOverlay.dismissLoadingIndicator();
    if(conversations != null){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            bottom: _SearchBar(
              onSearch: (value) {
                debouncer.run(() {
                  searchQuery = value;
                  if(mounted){
                    setState(() {});
                  }
                });
              },
            ),
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
                        ),
                      ]),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 20, UiConstant.horizontalPadding, 0),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)), color: AppUiColor.ghostWhite),
                    child: TabBarView(children: [
                      Builder(
                        builder: (context) {
                          var m = conversations?.data ?? [];
                          bool searchCondition(Data d){
                            var isInMessage = d.message?.firstOrNull?.content?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
                            var isInProduct = d.product?.name?.toLowerCase().contains(searchQuery.toLowerCase()) == true;

                            return isInMessage || isInProduct;
                          }
                          var messages = searchQuery.isEmpty ? m : m.where((element) => searchCondition(element)).toList();
                          return ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (_, index) => InkWell(
                                  onTap: () async {
                                    await ChatScreenRoute(messages[index]).push(context);
                                    getConversations(load: false);
                                  },child: _ChatHeaderCard(messages[index],chatViewModel)));
                        }
                      ),
                      Builder(
                          builder: (context) {
                            var m = conversations?.data ?? [];
                            bool searchCondition(Data d){
                              var isInMessage = d.message?.firstOrNull?.content?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
                              var isInProduct = d.product?.name?.toLowerCase().contains(searchQuery.toLowerCase()) == true;

                              return isInMessage || isInProduct;
                            }
                            var messages = searchQuery.isEmpty ? m : m.where((element) => searchCondition(element)).toList();

                            var unreadMessages = messages.where((element) => element.message?.firstOrNull?.isRead == false).toList();
                            return ListView.builder(
                                itemCount: unreadMessages.length,
                                itemBuilder: (_, index) => InkWell(
                                    onTap: () async {
                                      await ChatScreenRoute(unreadMessages[index]).push(context);
                                      getConversations(load: false);
                                    },child: _ChatHeaderCard(unreadMessages[index],chatViewModel)));
                          }
                      ),
                      Builder(
                          builder: (context) {
                            var m = conversations?.data ?? [];
                            bool searchCondition(Data d){
                              var isInMessage = d.message?.firstOrNull?.content?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
                              var isInProduct = d.product?.name?.toLowerCase().contains(searchQuery.toLowerCase()) == true;

                              return isInMessage || isInProduct;
                            }
                            var messages = searchQuery.isEmpty ? m : m.where((element) => searchCondition(element)).toList();

                            var readMessages = messages.where((element) => element.message?.firstOrNull?.isRead == true).toList();
                            return ListView.builder(
                                itemCount: readMessages.length,
                                itemBuilder: (_, index) => InkWell(
                                  onTap: () async {
                                    await ChatScreenRoute(readMessages[index]).push(context);
                                    getConversations(load: false);
                                  },
                                    child: _ChatHeaderCard(readMessages[index],chatViewModel)));
                          }
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}
