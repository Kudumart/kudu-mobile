part of '../screen.dart';

class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ServiceIcon(_Service(
            outline: AppUiColor.primary.withOpacity(0.32),
            background: AppUiColor.primary.withOpacity(0.14),
            label: "Auction",
            iconAssetUrl: AppUiImage.auction)),
        _ServiceIcon(_Service(
            outline: const Color(0xFF4CD964).withOpacity(0.30),
            background: const Color(0xFF4CD964).withOpacity(0.15),
            label: "Sell on Kudu",
            iconAssetUrl: AppUiImage.sell)),
        _ServiceIcon(_Service(
            outline: AppUiColor.primary.withOpacity(0.32),
            background: AppUiColor.primary.withOpacity(0.14),
            label: "Jobs",
            iconAssetUrl: AppUiImage.jobs)),
        _ServiceIcon(_Service(
            outline: const Color(0xFF276076).withOpacity(0.36),
            background: const Color(0xFF276076).withOpacity(0.15),
            label: "FAQ",
            iconAssetUrl: AppUiImage.faq)),
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
  const _ServiceIcon(this.service);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 80,
          width: 80,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: service.background,
              shape: BoxShape.circle,
              border: Border.all(color: service.outline)),
          child: Image.asset(
            service.iconAssetUrl,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          service.label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
