part of '../screen.dart';

class _SubscriptionOptions extends StatelessWidget {
  const _SubscriptionOptions();

  @override
  Widget build(BuildContext context) {
    return _SectionBackground(
      children: [
        const Text(
            "Choose a promotion type for your advert to reach more customer",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 22),

        // free post
        Container(
          height: 48,
          padding: const EdgeInsets.fromLTRB(19, 12, 13, 13),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD2D2D2)),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("No Promo",
                  style: TextStyle(fontSize: 13, color: Color(0xFF1A3B5D))),
              Text("Free",
                  style: TextStyle(fontSize: 13, color: Color(0xFF34A853)))
            ],
          ),
        ),

        const SizedBox(height: 19),

        // top up promo
        const _TopUpPromo()
      ],
    );
  }
}

class _TopUpPromo extends StatelessWidget {
  const _TopUpPromo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144,
      padding: const EdgeInsets.fromLTRB(19, 13, 20, 22),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF34A853)),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0x1C34A853)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("TOP Promo", style: TextStyle(fontSize: 14.5)),
          SizedBox(height: 3),
          Text(
              "Your advert would be at the top of our search result and get 12x more traffic",
              style: TextStyle(fontSize: 12, color: Color(0xFF939393))),
          SizedBox(height: 12),
          Row(
            children: [
              _Duration(duration: "7 Days", isActive: true),
              SizedBox(width: 9),
              _Duration(duration: "30 Days", isActive: false),
              Expanded(child: SizedBox()),
              Text(
                "\$10",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF34A853)),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _Duration extends StatelessWidget {
  final String duration;
  final bool isActive;
  const _Duration({required this.duration, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(
              color:
                  isActive ? const Color(0xFF34A853) : const Color(0x8C34A853)),
          borderRadius: BorderRadius.circular(3),
          color: isActive ? const Color(0x3634A853) : const Color(0xFFE9F5EC)),
      child: Text(duration,
          style: TextStyle(
              fontSize: 13,
              color: isActive
                  ? const Color(0xFF34A853)
                  : const Color(0x8C34A853))),
    );
  }
}
