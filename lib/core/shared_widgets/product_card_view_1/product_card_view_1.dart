import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudu/app/routes/routes.dart';

import '../../../models/enums_and_extensions.dart';
import '../../../models/product.dart';
import '../../colors.dart';
import '../../constants.dart';
import '../../images.dart';
import '../bookmark_button.dart';
import '../product_condition.dart';

part 'sub_widgets/image_view.dart';
part 'sub_widgets/add_button.dart';
part 'sub_widgets/location.dart';
part 'sub_widgets/price_view.dart';

class ProductCardView1 extends StatelessWidget {
  final Product product;

  /// [ProductCardView1] implements this Figma component design
  /// https://www.figma.com/design/OjLFKOOw0L8w2gqsQURFdq/Kudu-App?node-id=2669-1304&t=pSr82LIy4K42q3KI-4
  const ProductCardView1(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ProductDetailsScreenRoute(product.id).push(context),
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
        constraints: BoxConstraints(
            maxWidth: _widthPerProductCard(context), maxHeight: 287),
        decoration: BoxDecoration(
            border: Border.all(color: AppUiColor.borderline),
            borderRadius: BorderRadius.circular(11),
            color: Colors.white),
        child: Column(
          children: [
            Expanded(
                child: _ImageView(
                    imageUrls: product.imagesUrl, status: product.condition)),
            const SizedBox(height: 6),
            // title
            Text(
              ' product.name',
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5F5F5F),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            // location
            _Location(product.location),
            const SizedBox(height: 8),
            _PriceView(formattedPrice: product.formatPrice())
          ],
        ),
      ),
    );
  }

  double _widthPerProductCard(BuildContext context) {
    const maxSpacingBetweenProducts = 10;
    return (MediaQuery.sizeOf(context).width -
            (UiConstant.horizontalPadding * 2) -
            maxSpacingBetweenProducts) /
        2;
  }
}
