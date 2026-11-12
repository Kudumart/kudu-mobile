part of '../screen.dart';

class _ImagesPreview extends StatelessWidget {
  final List<String>? imagesUrl;
  final ProductCondition? condition;
  final bool isVerified;

  const _ImagesPreview(
    this.imagesUrl, {
    this.condition,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Container(
          width: double.infinity,
          alignment: Alignment.bottomLeft,
          child: Stack(
            children: [
              CarouselAppImage(
                imgUrls: imagesUrl ?? [],
                height: double.infinity,
                width: double.infinity,
                radius: 0,
                containerHeight: double.infinity,
                containerWidth: double.infinity,
                fit: BoxFit.cover,
                backgroundColor: Colors.transparent,
              ),

              // Photo counter at bottom-left
              Positioned(
                left: 14,
                bottom: 12,
                child: Container(
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.50),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (imagesUrl?.length ?? 0).toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      SvgPicture.asset(
                        AppUiIcon.camera,
                        height: 14,
                        width: 14,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),

              // Subtle tags on the image at bottom-right
              Positioned(
                right: 14,
                bottom: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (condition != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: condition == ProductCondition.brandNew
                              ? const Color(0xFFDCFCE7).withOpacity(0.92)
                              : const Color(0xFFFEE2E2).withOpacity(0.92),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: condition == ProductCondition.brandNew
                                ? const Color(0xFF86EFAC).withOpacity(0.85)
                                : const Color(0xFFFECACA).withOpacity(0.85),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          condition == ProductCondition.brandNew ? "Brand New" : "Used",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: condition == ProductCondition.brandNew
                                ? const Color(0xFF15803D)
                                : const Color(0xFFB91C1C),
                          ),
                        ),
                      ),
                    if (isVerified) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7).withOpacity(0.92),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF86EFAC).withOpacity(0.85),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.verified_rounded,
                              size: 13,
                              color: Color(0xFF15803D),
                            ),
                            SizedBox(width: 3),
                            Text(
                              "Verified",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
