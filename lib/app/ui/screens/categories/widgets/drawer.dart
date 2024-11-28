part of '../screen.dart';

class _Drawer extends StatefulWidget {
  const _Drawer();

  @override
  State<_Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<_Drawer> {
  int? _activeCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: MediaQuery.sizeOf(context).width * 0.39,
      height: MediaQuery.sizeOf(context).height - kToolbarHeight - 70,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _CategoryItem(
              onPressed: () => _setActiveIndex(0),
              isActive: _activeCategoryIndex == 0,
              svgIconUrl: AppUiIcon.car,
              label: "Vehicles"),
          const SizedBox(height: 10),
          _CategoryItem(
              onPressed: () => _setActiveIndex(1),
              isActive: _activeCategoryIndex == 1,
              svgIconUrl: AppUiIcon.mobileDevice,
              label: "Phones & Tablets"),
          const SizedBox(height: 10),
          _CategoryItem(
              onPressed: () => _setActiveIndex(2),
              isActive: _activeCategoryIndex == 2,
              svgIconUrl: AppUiIcon.television,
              label: "Electronics"),
          const SizedBox(height: 10),
          _CategoryItem(
              onPressed: () => _setActiveIndex(3),
              isActive: _activeCategoryIndex == 3,
              svgIconUrl: AppUiIcon.hairDryer,
              label: "Health & Beauty"),
          const SizedBox(height: 10),
          _CategoryItem(
              onPressed: () => _setActiveIndex(4),
              isActive: _activeCategoryIndex == 4,
              svgIconUrl: AppUiIcon.officeChair,
              label: "Home & Office"),
          const SizedBox(height: 10),
          _CategoryItem(
              onPressed: () => _setActiveIndex(5),
              isActive: _activeCategoryIndex == 5,
              svgIconUrl: AppUiIcon.house,
              label: "Properties"),
          const SizedBox(height: 10),
          _CategoryItem(
              onPressed: () => _setActiveIndex(6),
              isActive: _activeCategoryIndex == 6,
              svgIconUrl: AppUiIcon.clothHanger,
              label: "Fashion"),
          const SizedBox(height: 10),
          _CategoryItem(
              onPressed: () => _setActiveIndex(7),
              isActive: _activeCategoryIndex == 7,
              svgIconUrl: AppUiIcon.football,
              label: "Sport"),
          const SizedBox(height: 10),
          _CategoryItem(
              onPressed: () => _setActiveIndex(8),
              isActive: _activeCategoryIndex == 8,
              svgIconUrl: AppUiIcon.pawPrint,
              label: "Pets"),
          const SizedBox(height: 10),
          _CategoryItem(
              onPressed: () => _setActiveIndex(9),
              isActive: _activeCategoryIndex == 9,
              svgIconUrl: AppUiIcon.headset,
              label: "Services"),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  _setActiveIndex(int index) {
    setState(() => _activeCategoryIndex = index);
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
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(18, 10, 25, 10),
        decoration: const BoxDecoration(
            color: AppUiColor.grey50,
            border:
                Border(left: BorderSide(width: 2, color: AppUiColor.primary))),
        child: Row(
          children: [
            SvgPicture.asset(svgIconUrl,
                height: 24, width: 24, fit: BoxFit.contain),
            const SizedBox(width: 10),
            Expanded(
                child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ))
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 20),
      constraints: const BoxConstraints(minWidth: 100),
      child: Row(
        children: [
          SvgPicture.asset(svgIconUrl,
              height: 24, width: 24, fit: BoxFit.contain),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ))
        ],
      ),
    );
  }
}
