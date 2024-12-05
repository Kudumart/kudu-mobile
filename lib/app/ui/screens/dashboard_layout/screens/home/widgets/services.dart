part of '../screen.dart';

class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ServiceIcon(
            _Service(
                outline: AppUiColor.primary.withOpacity(0.32),
                background: AppUiColor.primary.withOpacity(0.14),
                label: "Auction",
                iconAssetUrl: AppUiImage.auction), onPressed: () {
          if (AppStorage.isLoggedInUser()) {
            const AuctionScreenRoute().push(context);
          } else {
            const SignUpOptionsScreenRoute(UserType.customer).push(context);
          }
        }),
        const SizedBox(width: 10),
        _ServiceIcon(
            _Service(
                outline: const Color(0xFF4CD964).withOpacity(0.30),
                background: const Color(0xFF4CD964).withOpacity(0.15),
                label: "Sell on Kudu",
                iconAssetUrl: AppUiImage.sell),
            onPressed: () =>
                const SignUpOptionsScreenRoute(UserType.vendor).push(context)),
        const SizedBox(width: 10),
        _ServiceIcon(
            _Service(
                outline: AppUiColor.primary.withOpacity(0.32),
                background: AppUiColor.primary.withOpacity(0.14),
                label: "Stores",
                iconAssetUrl: AppUiImage.jobs), onPressed: () {
          if (!AppStorage.isLoggedInUser()) {
            const SignUpOptionsScreenRoute(UserType.vendor).push(context);
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
      ],
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
