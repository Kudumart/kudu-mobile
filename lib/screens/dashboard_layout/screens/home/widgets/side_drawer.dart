part of '../screen.dart';

class _SideDrawer extends StatelessWidget {
  const _SideDrawer();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = StorageService().getBool('isLoggedIn') ?? false;
    final model = Provider.of<HomeViewModel>(context);

    return Container(
      color: Colors.white,
      width: context.width * 0.7,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Item(
                    iconAssetUrl: AppUiIcon.auctionOutline,
                    label: "Auction",
                    onPressed: () {
                      if (isLoggedIn) {
                        context.pop();
                        const AuctionLandingScreenRoute().push(context);
                      } else {
                        const SignUpOptionsScreenRoute(UserType.customer)
                            .push(context);
                      }
                    }),
                _Item(
                    iconAssetUrl: AppUiIcon.cvOutline,
                    label: "Jobs",
                    onPressed: () {
                      if (isLoggedIn) {
                        context.pop();
                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context) => const JobsSearchScreen()));
                      } else {
                        const SignUpOptionsScreenRoute(UserType.customer).push(context);
                      }
                    }),
                _Item(
                    iconAssetUrl: AppUiIcon.announcement,
                    label: "Adverts",
                    onPressed: () {
                      if (isLoggedIn) {
                        context.pop();
                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context) => const AdvertsScreen()));
                      } else {
                        const SignUpOptionsScreenRoute(UserType.customer).push(context);
                      }
                    }),
                if (!isLoggedIn)
                  _Item(
                    iconAssetUrl: AppUiIcon.storeFront,
                    label: "Become a Vendor",
                    onPressed: () {
                      context.pop();
                      const SignUpOptionsScreenRoute(UserType.vendor).push(context);
                    },
                  ),
                // _Item(
                //   iconAssetUrl: AppUiIcon.announcement,
                //   label: "Advertise Your Product",
                //   onPressed: () {
                //     context.pop();
                //   },
                // ),
                if (model.accountType == 'Vendor')
                  _Item(
                      iconAssetUrl: AppUiIcon.subscription,
                      label: "Subscriptions",
                      onPressed: () {
                        if (isLoggedIn) {
                          context.pop();
                          const SubscriptionScreenRoute().push(context);
                        } else {
                          const SignUpOptionsScreenRoute(UserType.vendor)
                              .push(context);
                        }
                      }),
                _Item(
                    iconAssetUrl: AppUiIcon.settings,
                    label: "Settings",
                    onPressed: () {
                      if (isLoggedIn) {
                        context.pop();
                        const SettingsScreenRoute().push(context);
                      } else {
                        const SignUpOptionsScreenRoute(UserType.customer)
                            .push(context);
                      }
                    }),
                _Item(
                    iconAssetUrl: AppUiIcon.info,
                    label: "FAQS",
                    onPressed: () {
                      context.pop();
                      const FAQScreenRoute().push(context);
                    }),
                _Item(
                    iconAssetUrl: AppUiIcon.privacyPolicy,
                    label: "Privacy Policy",
                    onPressed: () {
                      context.pop();
                      const PrivacyPolicyScreenRoute().push(context);
                    }),
                _Item(
                    iconAssetUrl: AppUiIcon.aboutKudu,
                    label: "About KUDU",
                    onPressed: () {
                      context.pop();
                      const AboutUsScreenRoute().push(context);
                    }),
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
    return ListTile(
      leading: SvgPicture.asset(iconAssetUrl, height: 28, width: 28, fit: BoxFit.contain),
      title: Text(
        label,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color(0xFF212121)),
      ),
      contentPadding: const EdgeInsets.all(0),
      onTap: onPressed,
    );
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          SvgPicture.asset(iconAssetUrl, height: 24, width: 24, fit: BoxFit.contain),
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
