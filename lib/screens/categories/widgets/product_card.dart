part of '../screen.dart';

class _ProductCard extends StatelessWidget {
  final Product product;
  final double maxWidth;

  const _ProductCard(this.product, {required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image preview
          (product.imagesUrl == null || product.imagesUrl!.isEmpty)
              ? Image.asset(AppUiImage.brokenImageIcon,
                  height: 176, width: maxWidth, fit: BoxFit.cover)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(product.imagesUrl!.first,
                      height: 176, width: maxWidth, fit: BoxFit.cover),
                ),
          const SizedBox(height: 15),

          Text(
            _formatProductName(),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }

  String _formatProductName() {
    if (product.name.length > 18) {
      return product.name.substring(0, 18);
    }

    return product.name;
  }
}
