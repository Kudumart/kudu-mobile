part of '../screen.dart';

class _TrendingProductCard extends StatelessWidget {
  final Product product;
  const _TrendingProductCard(this.product);

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
              product.name,
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

class _Location extends StatelessWidget {
  final String location;
  const _Location(this.location);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AppUiIcon.location,
            colorFilter:
                const ColorFilter.mode(AppUiColor.primary, BlendMode.srcIn),
            height: 14,
            width: 14,
            fit: BoxFit.contain),
        const SizedBox(width: 5),
        Text(
          location,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppUiColor.primary),
        ),
      ],
    );
  }
}

class _PriceView extends StatelessWidget {
  final String formattedPrice;
  const _PriceView({required this.formattedPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.fromLTRB(12, 3, 3, 3),
      decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(14.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formattedPrice,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          const _AddButton(),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 31,
      width: 31,
      decoration: const BoxDecoration(
          color: AppUiColor.primary, shape: BoxShape.circle),
      child: const Icon(CupertinoIcons.add, color: Colors.white, size: 18),
    );
  }
}

class _ImageView extends StatelessWidget {
  final List<String>? imageUrls;
  final ProductCondition status;
  const _ImageView({required this.imageUrls, required this.status});

  @override
  Widget build(BuildContext context) {
    if (imageUrls == null || imageUrls!.isEmpty) {
      return Image.asset(AppUiImage.brokenImageIcon);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset(imageUrls!.first).image, fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: const EdgeInsets.only(right: 5, top: 6),
                child: ProductUsageBanner(status)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ImagesCountView(imageUrls?.length ?? 1),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: BookmarkButton.outline(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ImagesCountView extends StatelessWidget {
  final int count;
  const _ImagesCountView(this.count);

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
