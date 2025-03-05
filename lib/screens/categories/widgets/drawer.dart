part of '../screen.dart';

class _Drawer extends StatefulWidget {
  final Function() closeDrawer;
  const _Drawer({required this.closeDrawer});

  @override
  State<_Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<_Drawer> {
  String? _activeCategory;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.only(top: 20),
      height: MediaQuery.sizeOf(context).height - kToolbarHeight - 70,
      color: Colors.white,
      duration: const Duration(milliseconds: 700),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.39,
            child: FutureBuilder(
              initialData: Provider.of<HomeViewModel>(context, listen: false).categoriesModel,
              future: Provider.of<HomeViewModel>(context, listen: false).fetchCategories(context: context),
              builder: (context,snapshot) {
                if(snapshot.hasData){
                  var categories = snapshot.data?.data ?? [];
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      var category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CategoryItem(
                          onPressed: () => _setActiveIndex(category.id ?? ""),
                          isActive: _activeCategory == category.id,
                          svgIconUrl: category.image ?? "",
                          label: category.name ?? "",
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // sub-categories
          if (_activeCategory != null)
            Container(
              width: MediaQuery.sizeOf(context).width * 0.45,
              padding: const EdgeInsets.fromLTRB(10, 5, 18, 10),
              child: Builder(
                builder: (context) {
                  var category = (Provider.of<HomeViewModel>(context).categoriesModel?.data)?.firstWhere((element) => element.id == _activeCategory);
                  var data = category?.subCategories ?? [];
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var category = data[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SubCategoryItem(
                          closeDrawer: widget.closeDrawer,
                          name: category.name ?? "",
                          imageAssetUrl: category.image ?? ""
                        ),
                      );
                    },
                  );
                  return Column(
                    children: _categoriesToSubCategories[_activeCategory] ?? [],
                  );
                }
              ),
            )
        ],
      ),
    );
  }

  _setActiveIndex(String category) {
    setState(() => _activeCategory = category);
  }

  late final Map<String, List<_SubCategoryItem>> _categoriesToSubCategories;

  @override
  void initState() {
    super.initState();
  }
}

class _SubCategoryItem extends StatelessWidget {
  final String name;
  final String imageAssetUrl;
  final Function() closeDrawer;
  const _SubCategoryItem(
      {required this.name,
      required this.closeDrawer,
      required this.imageAssetUrl,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeDrawer();
        ProductSearchScreenRoute(SearchFilter(category: name,subCategory: name,isSubCategory: true)).push(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(minWidth: 100),
        child: Row(
          children: [
            AppImage(
              imgUrl: imageAssetUrl,
              height: 24, width: 24, fit: BoxFit.contain,
              radius: 0,
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text(
              name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ))
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String svgIconUrl;
  final String label;
  final bool isActive;
  final Function() onPressed;
  const _CategoryItem(
      {required this.svgIconUrl,
      required this.onPressed,
      required this.isActive,
      required this.label});

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(16, 10, 25, 10),
          margin: const EdgeInsets.only(left: 5),
          decoration: const BoxDecoration(
              color: AppUiColor.grey50,
              border: Border(left: BorderSide(width: 4, color: AppUiColor.grey50))),
          child: Row(
            children: [
              AppImage(
                imgUrl: svgIconUrl,
                height: 24, width: 24, fit: BoxFit.contain,
                radius: 0,
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ))
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(16, 10, 25, 10),
        margin: const EdgeInsets.only(left: 5),
        decoration: const BoxDecoration(
            color: AppUiColor.grey50,
            border: Border(left: BorderSide(width: 4, color: AppUiColor.primary))),
        child: Row(
          children: [
            AppImage(
              imgUrl: svgIconUrl,
              height: 24, width: 24, fit: BoxFit.contain,
              radius: 0,
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ))
          ],
        ),
      ),
    );
  }
}
