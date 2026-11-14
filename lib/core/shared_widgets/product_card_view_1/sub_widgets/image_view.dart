part of '../product_card_view_1.dart';

class ImageView extends StatefulWidget {
  final List<String>? imageUrls;
  final ProductCondition status;
  final ProductData product;
  final bool showBookmarkButton;
  final bool showVerifiedStatus;
  const ImageView({super.key, required this.imageUrls, required this.status, required this.product, this.showBookmarkButton = true, this.showVerifiedStatus = true});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
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
            if (widget.product.isSoldOut)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withAlpha(100),
                  child: const Center(
                    child: Text(
                      "SOLD OUT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

            // Top badges: Condition pill & verified logo
            Positioned(
              top: 6,
              right: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductConditionBanner(widget.status),
                  if (widget.showVerifiedStatus && widget.product.isVerified) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7).withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF86EFAC).withValues(alpha: 0.85),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Bottom elements: Images count & bookmark button
            Positioned(
              left: 6,
              right: 6,
              bottom: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImagesCountView(widget.imageUrls?.length ?? 0),
                  if (widget.showBookmarkButton)
                    BookmarkButton.outline(productId: widget.product.id),
                ],
              ),
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
