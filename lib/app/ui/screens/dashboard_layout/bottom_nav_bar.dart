part of 'dashboard_layout.dart';

class _CustomBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final Function(int, BuildContext) onSelectIndex;
  const _CustomBottomNavBar(
      {required this.activeIndex, required this.onSelectIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000), // #00000040 in hex (with opacity)
            offset: Offset(0, 4), // x and y offset (0px 4px)
            blurRadius: 16.2, // blur radius (16.2px)
            spreadRadius: 0, // spread radius (0px)
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () => onSelectIndex(0, context),
              child: _NavBarItem(
                  isActive: activeIndex == 0,
                  svgAssetIcon: AppUiIcon.home,
                  label: "Home")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => onSelectIndex(1, context),
              child: _NavBarItem(
                  isActive: activeIndex == 1,
                  svgAssetIcon: AppUiIcon.chat,
                  label: "Messages")),
          const SizedBox(width: 22),
          const _AddButton(),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => onSelectIndex(2, context),
              child: _NavBarItem(
                  isActive: activeIndex == 2,
                  svgAssetIcon: AppUiIcon.cart,
                  label: "Stores")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => onSelectIndex(3, context),
              child: _NavBarItem(
                  isActive: activeIndex == 3,
                  svgAssetIcon: AppUiIcon.user,
                  label: "Profile")),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final bool isActive;
  final String svgAssetIcon;
  final String label;
  const _NavBarItem(
      {required this.isActive,
      required this.svgAssetIcon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(
        minWidth: 45,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(svgAssetIcon,
              height: 24,
              width: 24,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  isActive ? AppUiColor.primary : AppUiColor.iconBlack,
                  BlendMode.srcIn)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                color: isActive ? AppUiColor.primary : AppUiColor.iconBlack),
          )
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
      height: 45,
      width: 45,
      decoration: const BoxDecoration(
          color: AppUiColor.primary, shape: BoxShape.circle),
      child: const Icon(CupertinoIcons.add, color: Colors.white, size: 18),
    );
  }
}
