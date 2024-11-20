part of '../screen.dart';

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 268,
      child: GridView.extent(
        semanticChildCount: 8,
        scrollDirection: Axis.vertical,
        maxCrossAxisExtent: 127,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        children: const [
          _Category(
              name: "Trending",
              background: Color(0xFFA5B3FF),
              iconAssetUrl: AppUiImage.trending,
              textColor: Colors.white),
          _Category(
              name: "Vehicles",
              background: Color(0xFF9DA0C1),
              iconAssetUrl: AppUiImage.vehicles,
              textColor: Colors.white),
          _Category(
              name: "Properties",
              background: Color(0xFFFFDEC1),
              iconAssetUrl: AppUiImage.properties,
              textColor: Color(0xFF434343)),
          _Category(
              name: "Furnitures",
              background: Color(0xFFFFDEC1),
              iconAssetUrl: AppUiImage.furniture,
              textColor: Color(0xFF434343)),
          _Category(
              name: "Electronics",
              background: Color(0xFFA5B3FF),
              iconAssetUrl: AppUiImage.electronics,
              textColor: Colors.white),
          _Category(
              name: "Devices",
              background: Color(0xFFE9C6FF),
              iconAssetUrl: AppUiImage.electronics,
              textColor: Color(0xFF434343)),
        ],
      ),
    );
  }
}

class _Category extends StatelessWidget {
  final String name;
  final String iconAssetUrl;
  final Color textColor;
  final Color background;
  const _Category(
      {required this.name,
      required this.background,
      required this.iconAssetUrl,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(iconAssetUrl,
                height: 82, width: 82, fit: BoxFit.contain),
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
