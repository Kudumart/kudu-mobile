part of '../screen.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final GetSubscriptionModel subscription;

  const SubscriptionPlanCard({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, model, child) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: subscription.isActiveForVendor!
                ? AppUiColor.primary
                : const Color(0xFFF6F6F6),
          ),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subscription.name!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subscription.isActiveForVendor!)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppUiColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Current Plan",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppUiColor.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              subscription.price == "0.00"
                  ? "Free"
                  : "\$ ${double.parse(subscription.price!).toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: AppUiColor.primary,
              ),
            ),
            const SizedBox(height: 24),
            _buildFeatureRow(
              "Duration",
              "${subscription.duration} month${subscription.duration! > 1 ? 's' : ''}",
            ),
            _buildFeatureRow(
              "Product Limit",
              "${subscription.productLimit} products",
            ),
            _buildFeatureRow(
              "Auction Access",
              subscription.allowsAuction! ? "Allowed" : "Not allowed",
            ),
            if (subscription.auctionProductLimit != null)
              _buildFeatureRow(
                "Auction Product Limit",
                "${subscription.auctionProductLimit} products",
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: subscription.isActiveForVendor!
                    ? null
                    : () {
                        model.initatePayment(
                          context: context,
                          amount: double.parse(subscription.price ?? "0"),
                          subscriptionPlanId: subscription.id!,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: subscription.isActiveForVendor!
                      ? Colors.grey[300]
                      : AppUiColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text(
                  subscription.isActiveForVendor!
                      ? "Current Plan"
                      : "Change Plan",
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFeatureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.check_mark_circled,
            color: Colors.black,
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
