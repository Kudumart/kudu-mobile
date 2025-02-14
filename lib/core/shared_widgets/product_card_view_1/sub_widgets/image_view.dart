part of '../product_card_view_1.dart';

class _ImageView extends StatelessWidget {
  final List<String>? imageUrls;
  final ProductCondition status;
  final ProductData product;
  const _ImageView({required this.imageUrls, required this.status, required this.product});

  @override
  Widget build(BuildContext context) {
    if (imageUrls == null || imageUrls!.isEmpty) {
      return Image.asset(AppUiImage.brokenImageIcon);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            AppImage(
              imgUrl: imageUrls?.firstOrNull ?? "",
              radius: 0,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(margin: const EdgeInsets.only(right: 5, top: 6), child: ProductConditionBanner(status)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImagesCountView(imageUrls?.length ?? 0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: BookmarkButton.outline(productId: product.id),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImagesCountView extends StatelessWidget {
  final int count;
  const ImagesCountView(this.count, {super.key});

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
