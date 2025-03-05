import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/data/storage/shared_preferences.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/providers/home_provider.dart';
import 'package:provider/provider.dart';

import '../../models/enums_and_extensions.dart';

part 'bottom_nav_bar.dart';

class DashboardLayout extends StatefulWidget {
  final Widget? currentPage;
  const DashboardLayout({ this.currentPage, super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: widget.currentPage,
          bottomNavigationBar: _CustomBottomNavBar(
          activeIndex: _getActiveIndex(context),
          onSelectIndex: _onSelectIndex,
        ),
      ),
    );
  }

  _onSelectIndex(int index, BuildContext context) {
    bool isLoggedIn = StorageService().getBool('isLoggedIn') ?? false;
    final model = Provider.of<HomeViewModel>(context, listen: false);

    switch (index) {
      case 0:
        const HomeScreenRoute().go(context);
      case 1:
        if (isLoggedIn) {
          const MessagesScreenRoute().go(context);
        } else {
          const SignUpOptionsScreenRoute(UserType.customer).push(context);
        }

      case 2:
        if (isLoggedIn) {
          model.accountType == "Customer"
              ? const MyCartScreenRoute().go(context)
              : const MyStoreScreenRoute().go(context);
        } else {
          const SignUpOptionsScreenRoute(UserType.vendor).push(context);
        }

      case 3:
        if (isLoggedIn) {
          const ProfileScreenRoute().go(context);
        } else {
          const SignUpOptionsScreenRoute(UserType.customer).push(context);
        }

      default:
        throw "Can not navigate to unknown index $index";
    }
  }

  int _getActiveIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final model = Provider.of<HomeViewModel>(context, listen: false);

    if (location.startsWith("/home")) {
      return 0;
    }
    if (location.startsWith("/messages")) {
      return 1;
    }

    if (model.accountType == "Customer"
        ? location.startsWith("/my-cart")
        : location.startsWith("/my-store")) {
      return 2;
    }

    if (location.startsWith("/profile")) {
      return 3;
    }
    return -1;
  }
}
