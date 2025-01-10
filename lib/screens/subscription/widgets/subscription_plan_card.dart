part of '../screen.dart';

class _SubscriptionPlanCard extends StatelessWidget {
  final Subscription plan;
  const _SubscriptionPlanCard(this.plan);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 435,
      margin: const EdgeInsets.only(bottom: 29),
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 40),
      decoration: BoxDecoration(
          border: Border.all(
              color:
                  plan.isActive ? AppUiColor.primary : const Color(0xFFF6F6F6)),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 8),
          Text(
            _price(),
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: AppUiColor.primary),
          ),
          const SizedBox(height: 23),
          ...plan.benefits.map((benefit) => Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(CupertinoIcons.check_mark_circled,
                        color: Colors.black, size: 14),
                    const SizedBox(width: 5),
                    Expanded(
                        child: Text(benefit,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black)))
                  ],
                ),
              )),
          const SizedBox(height: 30),
          plan.isActive
              ? ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                          (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7))),
                      backgroundColor:
                          const WidgetStatePropertyAll(Color(0xFF808080))),
                  child: const Text("Cancel Plan"))
              : ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                          (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7))),
                      backgroundColor:
                          const WidgetStatePropertyAll(AppUiColor.primary)),
                  child: const Text("Buy Plan"))
        ],
      ),
    );
  }

  String _price() {
    if (plan.price <= 0) {
      return "Free";
    }

    return PriceFormatter.formatPrice(
        price: plan.price, currency: plan.currency);
  }
}
