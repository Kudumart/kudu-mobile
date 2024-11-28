part of '../screen.dart';

class _SideDrawer extends StatelessWidget {
  const _SideDrawer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(28, 70, 22, 54),
      child: Column(
        children: [
          // app bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(AppUiImage.kuduLogo),
              GestureDetector(
                  onTap: () => _closeDrawer(context),
                  child: SvgPicture.asset(
                    AppUiIcon.close,
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ))
            ],
          ),
          const SizedBox(height: 20),
          // divider
          Container(color: AppUiColor.borderline, height: 1),
          const SizedBox(height: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Item(
                    iconAssetUrl: AppUiIcon.auctionOutline,
                    label: "Auction",
                    onPressed: () {}),
                _Item(
                    iconAssetUrl: AppUiIcon.cvOutline,
                    label: "Stores",
                    onPressed: () {}),
                _Item(
                    iconAssetUrl: AppUiIcon.info,
                    label: "FAQS",
                    onPressed: () {}),
                _Item(
                    iconAssetUrl: AppUiIcon.privacyPolicy,
                    label: "Privacy Policy",
                    onPressed: () {}),
                _Item(
                    iconAssetUrl: AppUiIcon.aboutKudu,
                    label: "About KUDU",
                    onPressed: () {}),
                _Item(
                    iconAssetUrl: AppUiIcon.settings,
                    label: "Settings",
                    onPressed: () {}),
                _Item(
                    iconAssetUrl: AppUiIcon.info,
                    label: "Help",
                    onPressed: () {}),
                _Item(
                    iconAssetUrl: AppUiIcon.logout,
                    label: "Logout",
                    onPressed: () => _logout(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _closeDrawer(BuildContext context) {
    if (Scaffold.of(context).isDrawerOpen) {
      context.pop();
    }
  }

  _logout(BuildContext context) {
    AppUiOverlay().showActionDialog(context, "logout",
        title: "Confirm Logout",
        info: "Are you sure you want to logout?",
        okayButtonText: "Logout", onPressedOkayButton: () {
      AppStorage.logout();
      const SignInScreenRoute().go(context);
    });
  }
}

class _Item extends StatelessWidget {
  final String iconAssetUrl;
  final String label;
  final Function() onPressed;
  const _Item(
      {required this.iconAssetUrl,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          SvgPicture.asset(iconAssetUrl,
              height: 24, width: 24, fit: BoxFit.contain),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF212121)),
          )
        ],
      ),
    );
  }
}
