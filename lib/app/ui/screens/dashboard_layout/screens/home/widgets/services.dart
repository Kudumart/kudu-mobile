part of '../screen.dart';

class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    final List<_Service> services = [
      _Service(
          outline: UiColor.primary.withOpacity(0.32),
          background: UiColor.primary.withOpacity(0.14),
          label: "Auction",
          iconAssetUrl: UiImage.auction),
      _Service(
          outline: const Color(0xFF4CD964).withOpacity(0.30),
          background: const Color(0xFF4CD964).withOpacity(0.15),
          label: "Sell on Kudu",
          iconAssetUrl: UiImage.sell),
      _Service(
          outline: UiColor.primary.withOpacity(0.32),
          background: UiColor.primary.withOpacity(0.14),
          label: "Jobs",
          iconAssetUrl: UiImage.jobs),
      _Service(
          outline: const Color(0xFF276076).withOpacity(0.36),
          background: const Color(0xFF276076).withOpacity(0.15),
          label: "FAQ",
          iconAssetUrl: UiImage.faq),
    ];
    return SizedBox(
      height: 115,
      width: MediaQuery.sizeOf(context).width,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) => _ServiceIcon(services[index]),
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
  const _ServiceIcon(this.service);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 89,
          width: 85,
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
