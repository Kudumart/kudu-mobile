part of '../../../screen.dart';

class _ImageView extends StatelessWidget {
  final List<String>? imageUrls;
  final ProductCondition status;
  const _ImageView({required this.imageUrls, required this.status});

  @override
  Widget build(BuildContext context) {
    if (imageUrls == null || imageUrls!.isEmpty) {
      return Image.asset(AppUiImage.brokenImageIcon);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset(imageUrls!.first).image, fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: const EdgeInsets.only(right: 5, top: 6),
                child: ProductUsageBanner(status)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ImagesCountView(imageUrls?.length ?? 1),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: BookmarkButton.outline(),
                  )
                ],
              ),
            )
          ],
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
      height: 23,
      width: 43,
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
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            AppUiIcon.camera,
            height: 15,
            width: 15,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
