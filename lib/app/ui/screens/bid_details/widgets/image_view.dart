part of '../screen.dart';

class _ImageView extends StatelessWidget {
  final List<String>? imageUrls;
  final AuctionStatus status;
  const _ImageView({required this.imageUrls, required this.status});

  @override
  Widget build(BuildContext context) {
    if (imageUrls == null || imageUrls!.isEmpty) {
      return Image.asset(AppUiImage.brokenImageIcon);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 280,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset(imageUrls!.first).image, fit: BoxFit.cover)),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ImagesCountView(imageUrls?.length ?? 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagesCountView extends StatelessWidget {
  final int count;
  const _ImagesCountView(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.46),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            AppUiIcon.camera,
            height: 20,
            width: 20,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  final AuctionStatus status;
  const _StatusView(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.46),
            borderRadius: BorderRadius.circular(5)),
        child: RichText(
          text: TextSpan(
              text: "Status: ",
              style: const TextStyle(fontSize: 14, color: Colors.white),
              children: [
                TextSpan(
                    text: status.printableName(),
                    style: TextStyle(color: _textColor(), fontSize: 14))
              ]),
        ));
  }

  Color _textColor() {
    switch (status) {
      case AuctionStatus.ongoing:
        return Colors.green;
      case AuctionStatus.upcoming:
        return const Color.fromARGB(255, 255, 156, 34);
      case AuctionStatus.closed:
        return Colors.white60;
      default:
        return Colors.black;
    }
  }
}
