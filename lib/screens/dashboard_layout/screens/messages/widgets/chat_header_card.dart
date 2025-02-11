part of '../screen.dart';

class _ChatHeaderCard extends StatelessWidget {
  final Data chatHeader;
  final ChatViewModel chatViewModel;
  const _ChatHeaderCard(this.chatHeader,this.chatViewModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      height: 106,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserCircleAvatar(getUserAvatar, circleRadius: 25, imageSize: const Size(47, 47)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userDisplayName,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF232323),
                    ),
                  ),
                  if(unreadMessagesCount > 0)...[
                    const SizedBox(width: 10),
                    _UnreadMessagesCountView(unreadMessagesCount),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Text(productName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                  child: RichText(text: TextSpan(
                text: lastMessageContent,
                children: [
                  if (hasAttachment)
                    const WidgetSpan(child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(Icons.attachment_rounded, color: AppUiColor.iconBlack, size: 16),),
                    )
                ],
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              )))
            ],
              ),
          )
        ],
      ),
    );
  }

  String get getUserAvatar{
    var currentUser = chatViewModel.userDataService.userData;
    if(currentUser?.id != chatHeader.receiverId){
      return chatHeader.receiverUser?.photo ?? "";
    }

    if(currentUser?.id != chatHeader.senderId){
      return chatHeader.senderUser?.photo ?? "";
    }
    return "";
  }

  String get userDisplayName{
    var currentUser = chatViewModel.userDataService.userData;
    if(currentUser?.id != chatHeader.receiverId){
      return chatHeader.receiverUser?.fullName ?? "";
    }

    if(currentUser?.id != chatHeader.senderId){
      return chatHeader.senderUser?.fullName ?? "";
    }
    return "";
  }

  int get unreadMessagesCount{
    return int.tryParse(chatHeader.unreadMessagesCount?.toString() ?? "") ?? 0;
  }

  String get productName{
    return chatHeader.product?.name ?? "";
  }

  String get lastMessageContent{
    return chatHeader.message?.firstOrNull?.content ?? "";
  }

  bool get hasAttachment{
    return (chatHeader.message?.firstOrNull?.fileUrl?.trim() ?? "").isNotEmpty;
  }
}
