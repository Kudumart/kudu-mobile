part of '../screen.dart';

class _BookmarkedProductCard extends StatelessWidget {
  final BookmarkedProduct bookmarked;
  const _BookmarkedProductCard(this.bookmarked);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.fromLTRB(12, 9, 11, 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.6, color: const Color(0xFFE3E3E3)),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Image.asset(
            bookmarked.product.imagesUrl?.first ?? AppUiImage.brokenImageIcon,
            height: 75,
            width: 75,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product name
                Expanded(
                    child: Text(
                  bookmarked.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF787878),
                      fontWeight: FontWeight.w500),
                )),
                const SizedBox(height: 8),
                Text(
                  "• ${formatDate(bookmarked.on, [dd, '-', mm, '-', yyyy])}",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF03A84E)),
                ),
                const SizedBox(height: 10),
                Text(
                  PriceFormatter.formatPrice(
                      price: bookmarked.product.price,
                      currency: bookmarked.product.currencySymbol),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                    color: AppUiColor.primary,
                    borderRadius: BorderRadius.circular(3)),
                child: const Text(
                  "DETAILS",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(CupertinoIcons.trash,
                      size: 16, color: AppUiColor.primary),
                  SizedBox(width: 3),
                  Text(
                    "REMOVE",
                    style: TextStyle(
                        fontSize: 12,
                        color: AppUiColor.primary,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
