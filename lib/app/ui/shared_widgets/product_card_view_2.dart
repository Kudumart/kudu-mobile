import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../images.dart';

class ProductCardView2 extends StatelessWidget {
  final Product product;
  final double maxWidth;

  /// [ProductCardView2] implements this Figma component
  /// https://www.figma.com/design/OjLFKOOw0L8w2gqsQURFdq/Kudu-App?node-id=2055-5772&t=pSr82LIy4K42q3KI-4
  const ProductCardView2(this.product, {required this.maxWidth, super.key});

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
              : Image.asset(product.imagesUrl!.first,
                  height: 176, width: maxWidth, fit: BoxFit.cover),
          const SizedBox(height: 15),

          // product name and rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatProductName(),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9E9E9E)),
              ),
              const Expanded(child: SizedBox()),
              Icon(
                Icons.star,
                color: product.rating != null && product.rating! > 0
                    ? const Color(0xFFFBBC05)
                    : const Color(0xFFD1D1D1),
                size: 16,
              ),
              const SizedBox(width: 3),
              Text(
                "${product.rating ?? 0.0}",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              )
            ],
          ),
          const SizedBox(height: 5),

          // price
          Text(
            product.formatPrice(),
            style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                fontFamily: "Roboto",
                color: Colors.black),
          )
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
