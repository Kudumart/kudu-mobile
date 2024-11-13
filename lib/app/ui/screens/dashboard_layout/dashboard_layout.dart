import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';

class DashboardLayout extends StatelessWidget {
  final Widget currentPage;
  const DashboardLayout({required this.currentPage, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: currentPage,
      bottomNavigationBar: _CustomBottomNavBar(
        activeIndex: _getActiveIndex(context),
        onSelectIndex: _onSelectIndex,
      ),
    );
  }

  _onSelectIndex(int index, BuildContext context) {
    switch (index) {
      case 0:
        const HomeScreenRoute().go(context);
      case 1:
        const MessagesScreenRoute().go(context);
      case 2:
        const CartScreenRoute().go(context);
      case 3:
        const CategoriesScreenRoute().go(context);
      case 4:
        const AccountScreenRoute().go(context);
      default:
        throw "Can not navigate to unknown index $index";
    }
  }

  int _getActiveIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith("/home")) {
      return 0;
    }
    if (location.startsWith("/messages")) {
      return 1;
    }

    if (location.startsWith("/cart")) {
      return 2;
    }

    if (location.startsWith("/categories")) {
      return 3;
    }
    if (location.startsWith("/account")) {
      return 4;
    }
    return -1;
  }
}

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
                  svgAssetIcon: AppIcon.home,
                  label: "Home")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => onSelectIndex(1, context),
              child: _NavBarItem(
                  isActive: activeIndex == 1,
                  svgAssetIcon: AppIcon.chat,
                  label: "Messages")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => onSelectIndex(2, context),
              child: _NavBarItem(
                  isActive: activeIndex == 2,
                  svgAssetIcon: AppIcon.cart,
                  label: "Cart")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => onSelectIndex(3, context),
              child: _NavBarItem(
                  isActive: activeIndex == 3,
                  svgAssetIcon: AppIcon.categories,
                  label: "Categories")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => onSelectIndex(0, context),
              child: _NavBarItem(
                  isActive: activeIndex == 4,
                  svgAssetIcon: AppIcon.user,
                  label: "Account")),
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
                  isActive ? AppColor.primary : AppColor.iconBlack,
                  BlendMode.srcIn)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isActive ? AppColor.primary : AppColor.iconBlack),
          )
        ],
      ),
    );
  }
}
