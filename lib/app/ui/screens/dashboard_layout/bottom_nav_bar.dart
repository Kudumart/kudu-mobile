import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/screens/dashboard_layout/screens/home/screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: HomeScreen(),
      bottomNavigationBar: _CustomBottomNavBar(),
    );
  }
}

class _CustomBottomNavBar extends StatefulWidget {
  const _CustomBottomNavBar();

  @override
  State<_CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<_CustomBottomNavBar> {
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
              onTap: () => _changeTab(0),
              child: const _NavBarItem(
                  isActive: true, svgAssetIcon: AppIcon.home, label: "Home")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => _changeTab(1),
              child: const _NavBarItem(
                  isActive: false,
                  svgAssetIcon: AppIcon.chat,
                  label: "Messages")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => _changeTab(2),
              child: const _NavBarItem(
                  isActive: false, svgAssetIcon: AppIcon.cart, label: "Cart")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => _changeTab(3),
              child: const _NavBarItem(
                  isActive: false,
                  svgAssetIcon: AppIcon.categories,
                  label: "Categories")),
          const SizedBox(width: 22),
          GestureDetector(
              onTap: () => _changeTab(0),
              child: const _NavBarItem(
                  isActive: false,
                  svgAssetIcon: AppIcon.user,
                  label: "Account")),
        ],
      ),
    );
  }

  _changeTab(int newIndex) {}
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
