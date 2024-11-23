part of '../screen.dart';
/*
class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ProductDetailsScreenRoute(product.id).push(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 220,
        padding: const EdgeInsets.fromLTRB(10, 11, 11, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppUiColor.borderline,
          ),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x40C9C9C9),
              offset: Offset(0, 6),
              blurRadius: 19.2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
                child: Row(
              children: [
                _ImagesPreview(product.imagesUrl),
                const SizedBox(width: 10),
                Expanded(child: _ProductInfoView(product))
              ],
            )),
            const SizedBox(height: 8),
            _Buttons(
              sellerPhoneNumber: product.sellerPhoneNumber,
            )
          ],
        ),
      ),
    );
  }
}

class _ImagesPreview extends StatelessWidget {
  final List<String>? imagesUrl;
  const _ImagesPreview(this.imagesUrl);

  @override
  Widget build(BuildContext context) {
    if (imagesUrl == null || imagesUrl!.isEmpty) {
      return Image.asset(AppUiImage.brokenImageIcon);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 147,
        width: 161,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            image: DecorationImage(image: Image.asset(imagesUrl!.first).image)),
        child: Container(
          height: 23,
          width: 43,
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(2),
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
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                AppUiIcon.camera,
                height: 16,
                width: 16,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductInfoView extends StatelessWidget {
  final Product product;
  const _ProductInfoView(this.product);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          product.name,
          maxLines: 2,
          style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF5F5F5F),
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 22),
        _LocationAndBookmark(location: product.location),
        const SizedBox(height: 15),
        _PriceAndUsageStatus(
            price: product.price,
            currencySymbol: product.currencySymbol,
            usageStatus: product.condition)
      ],
    );
  }
}

class _PriceAndUsageStatus extends StatelessWidget {
  final double price;
  final String currencySymbol;
  final ProductCondition usageStatus;
  const _PriceAndUsageStatus(
      {required this.price,
      required this.currencySymbol,
      required this.usageStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$currencySymbol$price",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        const Expanded(child: SizedBox()),
        Container(
          height: 24,
          width: 69,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: usageStatus == ProductCondition.brandNew
                  ? const Color(0xFF34A853)
                  : const Color(0xFFFF0F00)),
          child: Text(
            usageStatus == ProductCondition.brandNew ? "Brand New" : "Used",
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        )
      ],
    );
  }
}

class _LocationAndBookmark extends StatelessWidget {
  final String location;
  const _LocationAndBookmark({required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AppUiIcon.location,
            height: 18, width: 18, fit: BoxFit.contain),
        const SizedBox(width: 5),
        Text(
          location,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF5F5F5F)),
        ),
        const Expanded(child: SizedBox()),
        const BookmarkButton.outline()
      ],
    );
  }
}

class _Buttons extends StatelessWidget {
  final String? sellerPhoneNumber;
  const _Buttons({this.sellerPhoneNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            flex: 1,
            child: _Button(
              label: "Seller Info",
              icon: const Icon(
                CupertinoIcons.info_circle_fill,
                size: 22,
                color: AppUiColor.iconBlack,
              ),
              onPressed: () {},
            )),
        const SizedBox(width: 10),
        Flexible(
            flex: 1,
            child: _Button(
                useBorder: true,
                label: "Buy Now",
                icon: const Icon(CupertinoIcons.cart_fill_badge_plus,
                    size: 24, color: AppUiColor.iconBlack),
                onPressed: () {}))
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final Widget icon;
  final Function() onPressed;
  final bool useBorder;
  const _Button(
      {required this.label,
      this.useBorder = false,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: 47, maxHeight: 51),
        decoration: BoxDecoration(
            color: AppUiColor.primary.withOpacity(0.05),
            border: useBorder
                ? Border.all(color: AppUiColor.primary.withOpacity(0.1))
                : null,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
} */
