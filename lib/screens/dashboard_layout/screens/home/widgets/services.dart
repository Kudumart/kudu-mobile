part of '../screen.dart';

class _Services extends StatefulWidget {
  const _Services();

  @override
  State<_Services> createState() => _ServicesState();
}

class _ServicesState extends State<_Services> {

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = StorageService().getBool('isLoggedIn') ?? false;
    final model = Provider.of<HomeViewModel>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
      children: [
        _ServiceIcon(
            _Service(
                outline: AppUiColor.primary.withOpacity(0.32),
                background: AppUiColor.primary.withOpacity(0.14),
                label: "Auction",
                iconAssetUrl: AppUiImage.auction), onPressed: () {
          const AuctionLandingScreenRoute().push(context);
        }),
        const SizedBox(width: 10),
        _ServiceIcon(
            _Service(
                outline: const Color(0xFF4CD964).withOpacity(0.30),
                background: const Color(0xFF4CD964).withOpacity(0.15),
                label: "Sell on Kudu",
                iconAssetUrl: AppUiImage.sell), onPressed: () {
          if (!isLoggedIn) {
            const SignUpOptionsScreenRoute(UserType.vendor).push(context);
          } else {
            model.accountType == 'Vendor'
                ? const MyStoreScreenRoute().push(context)
                : showDialog(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('Switch Account'),
                content: const Text(
                  'Would you like to switch to a vendor account? This will allow you to complete the KYC process.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(c);
                      var response = await Provider.of<HomeViewModel>(context, listen: false).becomeVendor(context: context);
                      if(response){
                        const DoKYCScreenRoute().push(context);
                        AppUiOverlay().showSuccessSnackbarMessage(context, message: "You are now a vendor, please complete your KYC");
                      }
                    },
                    child: const Text('Switch to Vendor'),
                  ),
                ],
              ),
            );
          }
        }),
        const SizedBox(width: 10),
        _ServiceIcon(
            _Service(
                outline: AppUiColor.primary.withOpacity(0.32),
                background: AppUiColor.primary.withOpacity(0.14),
                label: "Stores",
                iconAssetUrl: AppUiImage.jobs), onPressed: () {
          if (!isLoggedIn) {
            const SignUpOptionsScreenRoute(UserType.vendor).push(context);
          } else {
            model.accountType == 'Vendor'
                ? const MyStoreScreenRoute().push(context)
                : showDialog(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('Switch Account'),
                content: const Text(
                  'Would you like to switch to a vendor account? This will allow you to complete the KYC process.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(c);
                      var response = await Provider.of<HomeViewModel>(context, listen: false).becomeVendor(context: context);
                      if(response){
                        const DoKYCScreenRoute().push(context);
                        AppUiOverlay().showSuccessSnackbarMessage(context, message: "You are now a vendor, please complete your KYC");
                      }
                    },
                    child: const Text('Switch to Vendor'),
                  ),
                ],
              ),
            );
          }
        }),
        const SizedBox(width: 10),
        _ServiceIcon(
            _Service(
                outline: const Color(0xFF276076).withOpacity(0.36),
                background: const Color(0xFF276076).withOpacity(0.15),
                label: "FAQ",
                iconAssetUrl: AppUiImage.faq),
            onPressed: () => const FAQScreenRoute().push(context)),
        const SizedBox(width: 10),
        _ServiceIcon(
            _Service(
                outline: const Color(0xFF9C27B0).withOpacity(0.32),
                background: const Color(0xFF9C27B0).withOpacity(0.14),
                label: "Services",
                iconAssetUrl: AppUiImage.toolBox),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ServicesMarketplaceScreen(),
              ));
            }),
      ],
      ),
    );
  }
}

class _Service {
  final String label;
  final Color background;
  final Color outline;
  final String iconAssetUrl;

  _Service(
      {required this.label,
      required this.background,
      required this.outline,
      required this.iconAssetUrl});
}

class _ServiceIcon extends StatelessWidget {
  final _Service service;
  final Function() onPressed;
  const _ServiceIcon(this.service, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 75,
            width: 75,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: service.background,
                shape: BoxShape.circle,
                border: Border.all(color: service.outline)),
            child: Image.asset(
              service.iconAssetUrl,
              fit: BoxFit.contain,
              height: 30,
              width: 30,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            service.label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
