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
    // if (widget.imageUrls == null || widget.imageUrls!.isEmpty) {
    //   return Image.asset(AppUiImage.brokenImageIcon);
    // }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            Stack(
              children: [
                AppImage(
                  imgUrl: widget.imageUrls?.firstOrNull ?? "",
                  radius: 0,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if(widget.product.isSoldOut)...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withAlpha(100),
                      child: const Center(
                        child: Text("SOLD OUT", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(margin: const EdgeInsets.only(right: 5, top: 6), child: ProductConditionBanner(widget.status)),
                    if(widget.showVerifiedStatus)...[
                      Container(margin: const EdgeInsets.only(right: 5, top: 6),
                        child: Container(
                          height: 24,
                          width: 69,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5), color: _backgroundColor()),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.product.isVerified ? "Verified" : "Not Verified",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: _textColor()),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
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

  Color _backgroundColor() {
    if(widget.product.isVerified) {
      return const Color(0xFF34A853);
    }else{
      return const Color.fromARGB(255, 238, 190, 15);
    }
  }

  Color _textColor() {
    if(widget.product.isVerified) {
      return Colors.white;
    }else{
      return Colors.black;
    }
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
