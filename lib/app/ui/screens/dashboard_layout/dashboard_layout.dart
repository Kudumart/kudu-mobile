import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';

part 'bottom_nav_bar.dart';

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