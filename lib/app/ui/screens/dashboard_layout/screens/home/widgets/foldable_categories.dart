part of '../screen.dart';

class _FoldableProductCategories extends StatefulWidget {
  const _FoldableProductCategories();

  @override
  State<_FoldableProductCategories> createState() =>
      _FoldableProductCategoriesState();
}

class _FoldableProductCategoriesState
    extends State<_FoldableProductCategories> {
  late bool _isFolded;
  static _foldedCategories(BoxConstraints constraints) =>
      _categories(constraints).sublist(0, 6);

  @override
  void initState() {
    super.initState();
    _isFolded = true;
  }

  @override
  Widget build(BuildContext context) {
    const spaceBetweenContainers = 8.0;
    final constraints = _calculateConstraints(MediaQuery.sizeOf(context).width,
        UiConstant.horizontalPadding, spaceBetweenContainers);
    return Column(
      children: [
        Wrap(
            spacing: spaceBetweenContainers,
            runSpacing: spaceBetweenContainers,
            children: _isFolded
                ? _foldedCategories(constraints)
                : _categories(constraints)),
        const SizedBox(height: 10),
        GestureDetector(
            onTap: () => setState(() => _isFolded = !_isFolded),
            child: Text(
              _isFolded ? "Load More" : "Show Less",
              style: const TextStyle(
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  decorationColor: AppUiColor.primary,
                  fontWeight: FontWeight.w500,
                  color: AppUiColor.primary),
            ))
      ],
    );
  }

  static BoxConstraints _calculateConstraints(double totalWidth,
      double horizontalPadding, double spaceBetweenContainers) {
    const maxWidth = 127.0;
    const maxHeight = 129.0;

    // Step 1: Calculate available width
    double availableWidth =
        totalWidth - (2 * horizontalPadding) - (2 * spaceBetweenContainers);

    // Step 2: Calculate width of each container (minimum of 3 per row)
    double containerWidth = availableWidth / 3;
    if (containerWidth > maxWidth) {
      containerWidth = maxWidth;
    }

    // Step 3: Calculate height using the aspect ratio (0.98)
    double containerHeight = containerWidth * 0.98;
    if (containerHeight > maxHeight) {
      containerHeight = maxHeight;
    }

    // Step 4: Create and return BoxConstraints
    return BoxConstraints(
      minWidth: containerWidth,
      maxWidth: containerWidth,
      minHeight: containerHeight,
      maxHeight: containerHeight,
    );
  }

  static _categories(BoxConstraints constraints) => [
        _Category(
            name: "Trending",
            constraints: constraints,
            background: const Color(0xFFA5B3FF),
            iconAssetUrl: AppUiImage.trending,
            textColor: Colors.white),
        _Category(
            name: "Vehicles",
            constraints: constraints,
            background: const Color(0xFF9DA0C1),
            iconAssetUrl: AppUiImage.vehicles,
            textColor: Colors.white),
        _Category(
            name: "Properties",
            constraints: constraints,
            background: const Color(0xFFFFDEC1),
            iconAssetUrl: AppUiImage.properties,
            textColor: const Color(0xFF434343)),
        _Category(
            name: "Furnitures",
            constraints: constraints,
            background: const Color(0xFFFFDEC1),
            iconAssetUrl: AppUiImage.furniture,
            textColor: const Color(0xFF434343)),
        _Category(
            name: "Electronics",
            constraints: constraints,
            background: const Color(0xFFA5B3FF),
            iconAssetUrl: AppUiImage.electronics,
            textColor: Colors.white),
        _Category(
            name: "Devices",
            constraints: constraints,
            background: const Color(0xFFE9C6FF),
            iconAssetUrl: AppUiImage.electronics,
            textColor: const Color(0xFF434343)),
        _Category(
            name: "Beauty",
            constraints: constraints,
            background: const Color(0xA3FF94AB),
            iconAssetUrl: AppUiImage.beauty,
            textColor: const Color(0xFF434343)),
        _Category(
            name: "Home",
            constraints: constraints,
            background: const Color(0xFFE4F9E8),
            iconAssetUrl: AppUiImage.kitchen,
            textColor: const Color(0xFF434343)),
        _Category(
            name: "Office",
            constraints: constraints,
            background: const Color(0xFFDFE7EA),
            iconAssetUrl: AppUiImage.officeChair,
            textColor: const Color(0xFF434343)),
        _Category(
            name: "Fashion",
            constraints: constraints,
            background: const Color(0xFFA5B3FF),
            iconAssetUrl: AppUiImage.redDress,
            textColor: Colors.white),
        _Category(
            name: "Sport",
            constraints: constraints,
            background: const Color(0xFF9DA0C1),
            iconAssetUrl: AppUiImage.sportEquipments,
            textColor: Colors.white),
        _Category(
            name: "Pet",
            constraints: constraints,
            background: const Color(0xFFFFDEC1),
            iconAssetUrl: AppUiImage.dog,
            textColor: const Color(0xFF434343)),
        _Category(
            name: "Services",
            constraints: constraints,
            background: const Color(0xFFE4F9E8),
            iconAssetUrl: AppUiImage.toolBox,
            textColor: const Color(0xFF434343)),
        _Category(
            name: "Health",
            constraints: constraints,
            background: const Color(0xA3FF94AB),
            iconAssetUrl: AppUiImage.cream,
            textColor: const Color(0xFF434343)),
        _Category(
            name: "Agriculture",
            constraints: constraints,
            background: const Color(0xFFDFE7EA),
            iconAssetUrl: AppUiImage.cream,
            textColor: const Color(0xFF434343)),
      ];
}

class _Category extends StatelessWidget {
  final BoxConstraints constraints;
  final String name;
  final String iconAssetUrl;
  final Color textColor;
  final Color background;
  const _Category(
      {required this.name,
      required this.constraints,
      required this.background,
      required this.iconAssetUrl,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          ProductSearchScreenRoute(SearchFilter(category: name)).push(context),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        constraints: constraints,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconAssetUrl,
                height: 60, width: 60, fit: BoxFit.contain),
            Text(name,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: textColor))
          ],
        ),
      ),
    );
  }
}
