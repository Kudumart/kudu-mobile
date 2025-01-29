// ignore_for_file: unused_element

part of 'controller.dart';

class _ChatMessageImageView extends StatelessWidget {
  final String image;
  final bool isSentByCurrentUser;
  final Color color;
  final bool tail;
  final DateTime sent;
  final bool seen;

  const _ChatMessageImageView({
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

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: EdgeInsets.only(
          bottom: 2,
          left:
              isSentByCurrentUser ? MediaQuery.of(context).size.width * .5 : 0,
          right: !isSentByCurrentUser
              ? MediaQuery.of(context).size.width * .5
              : 0),
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
                  height: 200,
                  width: 200,
                  errorWidget: (context, url, error) => Image.asset(
                      AppUiImage.brokenImageIcon,
                      height: 100,
                      width: 100,
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
      child: Scaffold(
        body: Center(
          child: image,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
