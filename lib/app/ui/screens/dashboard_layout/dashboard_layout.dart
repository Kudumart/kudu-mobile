import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/app/data/storage/shared_preferences.dart';
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
        if (!AppStorage.isLoggedInUser()) {
          const MessagesScreenRoute().go(context);
        } else {
          const SignUpOptionsScreenRoute().push(context);
        }

      case 2:
        if (AppStorage.isLoggedInUser()) {
          const MyStoreScreenRoute().go(context);
        } else {
          const SignUpOptionsScreenRoute().push(context);
        }

      case 3:
        if (AppStorage.isLoggedInUser()) {
          const ProfileScreenRoute().go(context);
        } else {
          const SignUpOptionsScreenRoute().push(context);
        }

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

    if (location.startsWith("/my-store")) {
      return 2;
    }

    if (location.startsWith("/profile")) {
      return 3;
    }
    return -1;
  }
}
