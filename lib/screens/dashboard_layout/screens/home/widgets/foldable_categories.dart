part of '../screen.dart';

class _FoldableProductCategories extends StatefulWidget {
  const _FoldableProductCategories();

  @override
  State<_FoldableProductCategories> createState() =>
      _FoldableProductCategoriesState();
}

class _FoldableProductCategoriesState extends State<_FoldableProductCategories> {
  late bool _isFolded;

  @override
  void initState() {
    super.initState();
    _isFolded = true;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    const spaceBetweenContainers = 8.0;
    final constraints = _calculateConstraints(MediaQuery.sizeOf(context).width, UiConstant.horizontalPadding, spaceBetweenContainers);

    return Column(
      children: [
        FutureBuilder(
          future: provider.fetchCategories(context: context),
          builder: (context,snapshot) {
            if(snapshot.hasData){
              var data = snapshot.data?.data ?? [];

              _isFolded = data.length > 6 ? _isFolded : false;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                      itemCount: (_isFolded && data.length >= 6) ? 6 : data.length,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => _Category(
                        name: data[index].name ?? "",
                        categoryId: data[index].id ?? "",
                        constraints: constraints,
                        background: const Color(0xFFA5B3FF),
                        iconAssetUrl: data[index].image ?? AppUiImage.trending,
                        textColor: Colors.white,
                      ),
                    )
                  ),
                  if(data.length > 6)...[
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
                ],
              );
            }
            return SizedBox(
              width: double.infinity,
              child: GridView.builder(
                itemCount: 6,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => _Category(
                  name: "Trending",
                  categoryId: "",
                  constraints: constraints,
                  background: const Color(0xFFA5B3FF),
                  iconAssetUrl: AppUiImage.trending,
                  isLoading: true,
                  textColor: Colors.white,
                ),
              )
            );
          },
        ),
      ],
    );
  }

  static BoxConstraints _calculateConstraints(double totalWidth, double horizontalPadding, double spaceBetweenContainers) {
    const maxWidth = 100.0;
    const maxHeight = 100.0;

    // Step 1: Calculate available width
    double availableWidth = totalWidth - (2 * horizontalPadding) - (2 * spaceBetweenContainers);

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
}

class _Category extends StatelessWidget {
  final BoxConstraints constraints;
  final String name;
  final String iconAssetUrl;
  final Color textColor;
  final Color background;
  final bool isLoading;
  final String categoryId;

  const _Category({
    required this.name,
    required this.categoryId,
    required this.constraints,
    required this.background,
    required this.iconAssetUrl,
    required this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(isLoading){
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: context.width * 0.25,
              height: context.width * 0.25,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () => ProductSearchScreenRoute(SearchFilter(category: name,categoryId: categoryId)).push(context),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: context.width * 0.4,
            height: context.width * 0.3,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage(
                  height: 40, width: 40,
                  imgUrl: iconAssetUrl,
                  backgroundColor: Colors.transparent,
                  fit: BoxFit.contain,
                  useImagePlaceholder: true,
                  radius: 0,
                  imagePlaceholder: Image.asset(AppUiImage.trending, height: 60, width: 60, fit: BoxFit.contain),
                  usePlaceHolder: true,
                ),
                5.height,
                Text(name,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: textColor),textAlign: TextAlign.center)
              ],
            ),
          ),
        );
      }
    );
  }
}
