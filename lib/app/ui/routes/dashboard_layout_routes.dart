part of 'routes.dart';

@TypedShellRoute<DashboardLayoutShellRouteData>(
  routes: <TypedRoute<RouteData>>[
  TypedGoRoute<HomeScreenRoute>(path: '/home'),
  TypedGoRoute<MessagesScreenRoute>(path: '/messages'),
  TypedGoRoute<CartScreenRoute>(path: '/cart'),
  TypedGoRoute<CategoriesScreenRoute>(path: '/categories'),
  TypedGoRoute<AccountScreenRoute>(path: '/account'),
])


class DashboardLayoutShellRouteData extends ShellRouteData {
  const DashboardLayoutShellRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey = _shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return DashboardLayout(currentPage: navigator);
  }
}

class HomeScreenRoute extends GoRouteData {
  const HomeScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _topToBottomSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

class MessagesScreenRoute extends GoRouteData {
  const MessagesScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MessagesScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

class CartScreenRoute extends GoRouteData {
  const CartScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const CartScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

class CategoriesScreenRoute extends GoRouteData {
  const CategoriesScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const CategoriesScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

class AccountScreenRoute extends GoRouteData {
  const AccountScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AccountScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _rightToLeftSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}
