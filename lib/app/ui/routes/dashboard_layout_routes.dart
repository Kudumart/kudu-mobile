part of 'routes.dart';

// Here are some guide to learn how stateful shell routing works
// https://pub.dev/packages/go_router_builder#typedshellroute-and-navigator-keys
// https://github.com/flutter/packages/blob/main/packages/go_router_builder/example/lib/shell_route_with_keys_example.dart

@TypedShellRoute<DashboardLayoutShellRouteData>(routes: <TypedRoute<RouteData>>[
  TypedGoRoute<HomeScreenRoute>(path: '/home'),
  TypedGoRoute<MessagesScreenRoute>(path: '/messages'),
  TypedGoRoute<MyStoreScreenRoute>(path: '/my-store'),
  TypedGoRoute<ProfileScreenRoute>(path: '/profile'),
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
          transitionDuration: const Duration(milliseconds: 750),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(opacity: animation, child: child);
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

class MyStoreScreenRoute extends GoRouteData {
  const MyStoreScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MyStoreScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final offset = Tween<Offset>(
              begin: _leftToRightSlideTransitionBeginOffset,
              end: _allSlideTransitionEndOffset,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          });
}

class ProfileScreenRoute extends GoRouteData {
  const ProfileScreenRoute();

  @override
  CustomTransitionPage<void> buildPage(
          BuildContext context, GoRouterState state) =>
      CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ProfileScreen(),
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
