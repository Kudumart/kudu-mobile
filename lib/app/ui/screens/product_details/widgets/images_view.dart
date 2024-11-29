part of '../screen.dart';

class _ImagesPreview extends StatelessWidget {
  final List<String>? imagesUrl;
  const _ImagesPreview(this.imagesUrl);

  @override
  Widget build(BuildContext context) {
    if (imagesUrl == null || imagesUrl!.isEmpty) {
      return Image.asset(AppUiImage.brokenImageIcon);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 280,
        width: double.infinity,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(imagesUrl!.first,
                        height: 280, width: double.infinity, fit: BoxFit.cover)
                    .image)),
        child: Container(
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
                imagesUrl!.length.toString(),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(AppUiIcon.camera,
                  height: 18, width: 18, fit: BoxFit.cover)
            ],
          ),
        ),
      ),
    );
  }
}
