part of '../screen.dart';

class _ImagesPreview extends StatelessWidget {
  final List<String>? imagesUrl;
  const _ImagesPreview(this.imagesUrl);

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
              Container(
                height: 26,
                width: 53,
                margin: const EdgeInsets.only(left: 16, bottom: 12),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.46),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (imagesUrl?.length ?? 0).toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(AppUiIcon.camera, height: 18, width: 18, fit: BoxFit.cover)
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
