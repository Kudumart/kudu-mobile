part of '../product_card_view_1.dart';

class ImageView extends StatefulWidget {
  final List<String>? imageUrls;
  final ProductCondition status;
  final ProductData product;
  final bool showBookmarkButton;
  const ImageView({super.key, required this.imageUrls, required this.status, required this.product, this.showBookmarkButton = true});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls == null || widget.imageUrls!.isEmpty) {
      return Image.asset(AppUiImage.brokenImageIcon);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            AppImage(
              imgUrl: widget.imageUrls?.firstOrNull ?? "",
              radius: 0,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(margin: const EdgeInsets.only(right: 5, top: 6), child: ProductConditionBanner(widget.status)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImagesCountView(widget.imageUrls?.length ?? 0),
                      if(widget.showBookmarkButton)...[
                        Builder(
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: BookmarkButton.outline(productId: widget.product.id),
                            );
                          }
                        ),
                      ],
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
