import 'package:flutter/material.dart';
import 'package:kudu/core/shared_widgets/app_image.dart';
import 'package:kudu/models/chat/conversation_list.dart';
import 'package:kudu/models/chat_header.dart';
import 'package:kudu/models/chat_message.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:provider/provider.dart';

import '../../../../core/colors.dart';
import '../../../../core/shared_widgets/overlay/overlay.dart';
import '../../../../providers/chat_view_model.dart';
import '../../../../core/shared_widgets/app_button.dart';

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
    if(conversations != null && mounted){
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
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: false,
          title: const Text(
            "Messages",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          bottom: _SearchBar(
            onSearch: (value) {
              debouncer.run(() {
                searchQuery = value;
                if (mounted) setState(() {});
              });
            },
          ),
        ),
        body: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: AppUiColor.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF4B5563),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      tabs: const [
                        Tab(text: "All Chats"),
                        Tab(text: "Unread"),
                        Tab(text: "Read"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Builder(
                        builder: (context) {
                          var m = conversations?.data ?? [];
                          bool searchCondition(ConversationListData d) {
                            var isInMessage = d.message?.firstOrNull?.content?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
                            var isInProduct = d.product?.name?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
                            return isInMessage || isInProduct;
                          }

                          var messages = searchQuery.isEmpty ? m : m.where((element) => searchCondition(element)).toList();

                          if (messages.isEmpty) {
                            return Center(
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
                                  const SizedBox(height: 16),
                                  const Text("No Messages Found", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                                  const SizedBox(height: 6),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                                    child: Text("You don't have any conversations in this view.", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 140,
                                    height: 42,
                                    child: AppButton(
                                      text: "Refresh",
                                      variant: AppButtonVariant.outline,
                                      onPressed: () => getConversations(load: true),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            itemCount: messages.length,
                            itemBuilder: (_, index) => InkWell(
                              onTap: () async {
                                await ChatScreenRoute(messages[index]).push(context);
                                getConversations(load: false);
                              },
                              child: _ChatHeaderCard(messages[index], chatViewModel),
                            ),
                          );
                        },
                      ),
                      Builder(
                          builder: (context) {
                            var m = conversations?.data ?? [];
                            bool searchCondition(ConversationListData d){
                              var isInMessage = d.message?.firstOrNull?.content?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
                              var isInProduct = d.product?.name?.toLowerCase().contains(searchQuery.toLowerCase()) == true;

                              return isInMessage || isInProduct;
                            }
                            var messages = searchQuery.isEmpty ? m : m.where((element) => searchCondition(element)).toList();

                            var unreadMessages = messages.where((element) => element.message?.firstOrNull?.isRead == false).toList();
                            
                            if (unreadMessages.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.mark_chat_read_outlined, size: 80, color: Colors.grey.shade400),
                                    const SizedBox(height: 20),
                                    const Text("All Caught Up!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                                    const SizedBox(height: 10),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                                      child: Text("You have no unread messages.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
                                    ),
                                    const SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                      child: AppButton(text: "Refresh", onPressed: () => getConversations(load: true)),
                                    ),
                                  ],
                                ),
                              );
                            }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            itemCount: unreadMessages.length,
                            itemBuilder: (_, index) => InkWell(
                              onTap: () async {
                                await ChatScreenRoute(unreadMessages[index]).push(context);
                                getConversations(load: false);
                              },
                              child: _ChatHeaderCard(unreadMessages[index], chatViewModel),
                            ),
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          var m = conversations?.data ?? [];
                          bool searchCondition(ConversationListData d) {
                            var isInMessage = d.message?.firstOrNull?.content?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
                            var isInProduct = d.product?.name?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
                            return isInMessage || isInProduct;
                          }

                          var messages = searchQuery.isEmpty ? m : m.where((element) => searchCondition(element)).toList();
                          var readMessages = messages.where((element) => element.message?.firstOrNull?.isRead == true).toList();

                          if (readMessages.isEmpty) {
                            return Center(
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
                                  const SizedBox(height: 16),
                                  const Text("No Read Messages", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                                  const SizedBox(height: 6),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                                    child: Text("You have no read messages to show.", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 140,
                                    height: 42,
                                    child: AppButton(
                                      text: "Refresh",
                                      variant: AppButtonVariant.outline,
                                      onPressed: () => getConversations(load: true),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            itemCount: readMessages.length,
                            itemBuilder: (_, index) => InkWell(
                              onTap: () async {
                                await ChatScreenRoute(readMessages[index]).push(context);
                                getConversations(load: false);
                              },
                              child: _ChatHeaderCard(readMessages[index], chatViewModel),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
