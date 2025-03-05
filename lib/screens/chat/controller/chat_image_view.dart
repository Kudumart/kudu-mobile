// ignore_for_file: unused_element

part of 'controller.dart';

class ChatMessageImageView extends StatelessWidget {
  final String image;
  final bool isSentByCurrentUser;
  final Color color;
  final bool tail;
  final DateTime sent;
  final bool seen;

  const ChatMessageImageView({
    super.key,
    required this.image,
    required this.isSentByCurrentUser,
    required this.color,
    this.tail = true,
    required this.sent,
    this.seen = false,
  });

  @override
  Widget build(BuildContext context) {
    const double bubbleRadius = 16.0;

    return Align(
      alignment: isSentByCurrentUser ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2,right: 20,left: 20,top: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(bubbleRadius),
            topRight: const Radius.circular(bubbleRadius),
            bottomLeft: Radius.circular(tail
                ? isSentByCurrentUser
                    ? bubbleRadius
                    : 0
                : bubbleRadius),
            bottomRight: Radius.circular(tail
                ? isSentByCurrentUser
                    ? 0
                    : bubbleRadius
                : bubbleRadius),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .5,
          maxHeight: MediaQuery.of(context).size.width * .5,
        ),
        child: GestureDetector(
          onTap: () => _showEnlargedView(context),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(bubbleRadius),
                child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                        AppUiImage.brokenImageIcon,
                        fit: BoxFit.contain),
                    fit: BoxFit.contain),
              ),
              if (seen)
                const Positioned(
                  bottom: 4,
                  right: 6,
                  child: Icon(
                    Icons.done_all,
                    size: 18,
                    color: Color(0xFF97AD8E),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  _showEnlargedView(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return _DetailScreen(
        image: CachedNetworkImage(
            imageUrl: image,
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).height,
            errorWidget: (context, url, error) => Image.asset(
                AppUiImage.brokenImageIcon,
                height: 100,
                width: 100,
                fit: BoxFit.contain),
            fit: BoxFit.contain),
      );
    }));
  }
}

class _DetailScreen extends StatelessWidget {
  final Widget image;

  const _DetailScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Scaffold(
            body: Center(
              child: image,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.cancel_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
