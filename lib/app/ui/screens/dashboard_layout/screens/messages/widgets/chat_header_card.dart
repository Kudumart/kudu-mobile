part of '../screen.dart';

class _ChatHeaderCard extends StatelessWidget {
  final ChatHeader chatHeader;
  const _ChatHeaderCard(this.chatHeader);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ChatScreenRoute(chatHeader).push(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        height: 106,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserCircleAvatar(chatHeader.counterpart.avatarUrl,
                circleRadius: 25, imageSize: const Size(47, 47)),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      chatHeader.counterpart.name,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF232323)),
                    ),
                    const SizedBox(width: 10),
                    _UnreadMessagesCountView(chatHeader.unreadMessagesCount)
                  ],
                ),
                const SizedBox(height: 3),
                Text(chatHeader.productName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Expanded(
                    child: RichText(
                        text: TextSpan(
                  text: chatHeader.lastMessage.content ??
                      "Sent a file attachment",
                  children: [
                    if (chatHeader.lastMessage.fileUrl != null &&
                        chatHeader.lastMessage.fileUrl!.isNotEmpty)
                      const WidgetSpan(
                          child: Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Icon(Icons.attachment_rounded,
                            color: AppUiColor.iconBlack, size: 16),
                      ))
                  ],
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400),
                )))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
