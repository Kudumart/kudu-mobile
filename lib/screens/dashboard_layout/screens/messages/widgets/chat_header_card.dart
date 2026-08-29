part of '../screen.dart';

class _ChatHeaderCard extends StatelessWidget {
  final ConversationListData chatHeader;
  final ChatViewModel chatViewModel;
  const _ChatHeaderCard(this.chatHeader,this.chatViewModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: ClipOval(
              child: getUserAvatar.isNotEmpty
                  ? AppImage(imgUrl: getUserAvatar, width: 46, height: 46, radius: 23, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        userDisplayName.isNotEmpty ? userDisplayName.substring(0, 1).toUpperCase() : "U",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppUiColor.primary),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        userDisplayName.isNotEmpty ? userDisplayName : "User",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    if (unreadMessagesCount > 0) ...[
                      _UnreadMessagesCountView(unreadMessagesCount),
                    ],
                  ],
                ),
                if (productName.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 5),
                Text(
                  lastMessageContent.isNotEmpty ? lastMessageContent : (hasAttachment ? "📷 Image attachment" : "No message content"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: unreadMessagesCount > 0 ? const Color(0xFF111827) : const Color(0xFF6B7280),
                    fontWeight: unreadMessagesCount > 0 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
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
