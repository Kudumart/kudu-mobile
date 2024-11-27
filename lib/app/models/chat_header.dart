class MessageHeader {
  final String? userAvatarUrl;
  final String username;
  final String productName;
  final String lastMessageSnippet;

  MessageHeader({
    this.userAvatarUrl,
    required this.username,
    required this.productName,
    required this.lastMessageSnippet,
  });
}
