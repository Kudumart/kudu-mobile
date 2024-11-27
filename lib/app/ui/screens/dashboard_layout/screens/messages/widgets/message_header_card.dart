part of '../screen.dart';

class _MessageHeaderCard extends StatelessWidget {
  final MessageHeader messageHeader;
  const _MessageHeaderCard(this.messageHeader);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      height: 106,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            messageHeader.userAvatarUrl ?? AppUiImage.userAvatar,
            height: 47,
            width: 47,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 20),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messageHeader.username,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF232323)),
              ),
              const SizedBox(height: 3),
              Text(messageHeader.productName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                  child: Text(
                messageHeader.lastMessageSnippet,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ))
            ],
          ))
        ],
      ),
    );
  }
}
