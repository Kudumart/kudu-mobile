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
          // categories
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.39,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Vehicles"),
                    isActive: _activeCategory == "Vehicles",
                    svgIconUrl: AppUiIcon.car,
                    label: "Vehicles"),
                const SizedBox(height: 10),
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Phones & Tablets"),
                    isActive: _activeCategory == "Phones & Tablets",
                    svgIconUrl: AppUiIcon.mobileDevice,
                    label: "Phones & Tablets"),
                const SizedBox(height: 10),
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Electronics"),
                    isActive: _activeCategory == "Electronics",
                    svgIconUrl: AppUiIcon.television,
                    label: "Electronics"),
                const SizedBox(height: 10),
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Health & Beauty"),
                    isActive: _activeCategory == "Health & Beauty",
                    svgIconUrl: AppUiIcon.hairDryer,
                    label: "Health & Beauty"),
                const SizedBox(height: 10),
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Home & Office"),
                    isActive: _activeCategory == "Home & Office",
                    svgIconUrl: AppUiIcon.officeChair,
                    label: "Home & Office"),
                const SizedBox(height: 10),
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Properties"),
                    isActive: _activeCategory == "Properties",
                    svgIconUrl: AppUiIcon.house,
                    label: "Properties"),
                const SizedBox(height: 10),
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Fashion"),
                    isActive: _activeCategory == "Fashion",
                    svgIconUrl: AppUiIcon.clothHanger,
                    label: "Fashion"),
                const SizedBox(height: 10),
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Sport"),
                    isActive: _activeCategory == "Sport",
                    svgIconUrl: AppUiIcon.football,
                    label: "Sport"),
                const SizedBox(height: 10),
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Pets"),
                    isActive: _activeCategory == "Pets",
                    svgIconUrl: AppUiIcon.pawPrint,
                    label: "Pets"),
                const SizedBox(height: 10),
                _CategoryItem(
                    onPressed: () => _setActiveIndex("Services"),
                    isActive: _activeCategory == "Services",
                    svgIconUrl: AppUiIcon.headset,
                    label: "Services"),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // sub-categories
          if (_activeCategory != null)
            Container(
              width: MediaQuery.sizeOf(context).width * 0.45,
              padding: const EdgeInsets.fromLTRB(10, 5, 18, 10),
              child: Column(
                children: _categoriesToSubCategories[_activeCategory] ?? [],
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
    _categoriesToSubCategories = {
      "Vehicles": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Cars",
            imageAssetUrl: AppUiImage.subcatVehicleCar),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Buses",
            imageAssetUrl: AppUiImage.subcatVehicleBus),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Bike & Scooters",
            imageAssetUrl: AppUiImage.subcatVehicleBike),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Heavy Machineries",
            imageAssetUrl: AppUiImage.subcatVehicleHeavy),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Vehicle Parts",
            imageAssetUrl: AppUiImage.subcatVehiclePart),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Truck & Trailers",
            imageAssetUrl: AppUiImage.subcatVehicleTrailer)
      ],
      "Phones & Tablets": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Phones",
            imageAssetUrl: AppUiImage.subcatDevicesPhones),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Tablets",
            imageAssetUrl: AppUiImage.subcatElectronicsLaptops),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Camera",
            imageAssetUrl: AppUiImage.subcatDevicesCamera),
      ],
      "Electronics": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Phones",
            imageAssetUrl: AppUiImage.subcatDevicesPhones),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Game Console",
            imageAssetUrl: AppUiImage.subcatElectronicsGameConsole),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Accessories",
            imageAssetUrl: AppUiImage.subcatDevicesHeadphone),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Laptops and Computers",
            imageAssetUrl: AppUiImage.subcatElectronicsLaptops),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Camera",
            imageAssetUrl: AppUiImage.subcatDevicesCamera),
      ],
      "Health & Beauty": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Creams",
            imageAssetUrl: AppUiImage.subcatVehicleCar),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Deodorant",
            imageAssetUrl: AppUiImage.subcatVehicleBus),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Perfumes",
            imageAssetUrl: AppUiImage.subcatVehicleBike),
      ],
      "Home & Office": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Chair",
            imageAssetUrl: AppUiImage.subcatHomeChair),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "CCTV",
            imageAssetUrl: AppUiImage.subcatOfficeCCTV),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Printer",
            imageAssetUrl: AppUiImage.subcatOfficePrinter),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Kitchen",
            imageAssetUrl: AppUiImage.subcatHomeKitchen),
      ],
      "Properties": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Apartment",
            imageAssetUrl: AppUiImage.subcatPropertyApartment),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Land",
            imageAssetUrl: AppUiImage.subcatPropertyLand),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Commercial Shortlet",
            imageAssetUrl: AppUiImage.subcatPropertyShortLet),
      ],
      "Fashion": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Creams",
            imageAssetUrl: AppUiImage.subcatVehicleCar),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Deodorant",
            imageAssetUrl: AppUiImage.subcatVehicleBus),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Perfumes",
            imageAssetUrl: AppUiImage.subcatVehicleBike),
      ],
      "Sport": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Gym Equipments",
            imageAssetUrl: AppUiImage.subcatHealthGymEquipment),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Training Facilities",
            imageAssetUrl: AppUiImage.subcatHealthGymEquipment),
      ],
      "Pets": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Teddy Bears",
            imageAssetUrl: AppUiImage.subcatHomeBaby),
      ],
      "Services": [
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Ride Hailing",
            imageAssetUrl: AppUiImage.subcatVehicleCar),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Buses Rentage",
            imageAssetUrl: AppUiImage.subcatVehicleBus),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Bike & Scooters",
            imageAssetUrl: AppUiImage.subcatVehicleBike),
        _SubCategoryItem(
            closeDrawer: widget.closeDrawer,
            name: "Heavy Machineries Operator",
            imageAssetUrl: AppUiImage.subcatVehicleHeavy),
      ]
    };
  }
}

class _SubCategoryItem extends StatelessWidget {
  final String name;
  final String imageAssetUrl;
  final Function() closeDrawer;
  const _SubCategoryItem(
      {required this.name,
      required this.closeDrawer,
      required this.imageAssetUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeDrawer();
        ProductSearchScreenRoute(SearchFilter(subCategory: name)).push(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(minWidth: 100),
        child: Row(
          children: [
            Image.asset(imageAssetUrl,
                height: 26, width: 26, fit: BoxFit.contain),
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
    if (isActive) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(16, 10, 25, 10),
        margin: const EdgeInsets.only(left: 5),
        decoration: const BoxDecoration(
            color: AppUiColor.grey50,
            border:
                Border(left: BorderSide(width: 4, color: AppUiColor.primary))),
        child: Row(
          children: [
            SvgPicture.asset(svgIconUrl,
                height: 24, width: 24, fit: BoxFit.contain),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
              label,
              style:
                  const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400),
            ))
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 20),
        constraints: const BoxConstraints(minWidth: 100),
        child: Row(
          children: [
            SvgPicture.asset(svgIconUrl,
                height: 24, width: 24, fit: BoxFit.contain),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
              label,
              style:
                  const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400),
            ))
          ],
        ),
      ),
    );
  }
}
